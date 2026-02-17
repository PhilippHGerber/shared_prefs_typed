import 'dart:convert';
import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:logging/logging.dart';
import 'package:shared_prefs_typed/shared_prefs_typed.dart';
import 'package:test/test.dart';

void main() async {
  final metaDir = await _findPackagePath('meta');

  final commonAssets = {
    'shared_prefs_typed_annotations|lib/shared_prefs_typed_annotations.dart': await File(
      '../shared_prefs_typed_annotations/lib/shared_prefs_typed_annotations.dart',
    ).readAsString(),
    'meta|lib/meta.dart': await File('$metaDir/lib/meta.dart').readAsString(),
    'meta|lib/meta_meta.dart': await File('$metaDir/lib/meta_meta.dart').readAsString(),
  };

  group('TypedPrefsGenerator', () {
    final builder = typedPrefsBuilder(BuilderOptions.empty);

    test(
      'should generate correct code for all supported types in sync mode',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/success_case.dart': await File(
            'test/src/success_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/success_case.g.dart': await File(
            'test/goldens/success_case.g.dart',
          ).readAsString(),
        };
        await testBuilder(
          builder,
          sourceAssets,
          outputs: expectedOutputs,
          rootPackage: 'my_package',
        );
      },
    );

    test(
      'should generate correct code for async mode',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/async_case.dart': await File('test/src/async_case.dart').readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/async_case.g.dart': await File(
            'test/goldens/async_case.g.dart',
          ).readAsString(),
        };
        await testBuilder(
          builder,
          sourceAssets,
          outputs: expectedOutputs,
          rootPackage: 'my_package',
        );
      },
    );

    test(
      'should generate abstract interface when generateInterface is true',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/interface_case.dart': await File(
            'test/src/interface_case.dart',
          ).readAsString(),
        };
        await testBuilder(
          builder,
          sourceAssets,
          rootPackage: 'my_package',
          outputs: {
            'my_package|lib/interface_case.g.dart': predicate<List<int>>(
              (bytes) {
                final content = utf8.decode(bytes);
                return content.contains('abstract class InterfacePrefsBase') &&
                    content.contains('int get counter;') &&
                    content.contains('String? get name;') &&
                    content.contains('Future<void> setCounter(int value);') &&
                    content.contains('bool isSetCounter();') &&
                    content.contains('Future<void> removeCounter();') &&
                    content.contains(
                      'class InterfacePrefs implements InterfacePrefsBase',
                    ) &&
                    content.contains('InterfacePrefs(this._prefs)') &&
                    content.contains('static InterfacePrefs get instance') &&
                    content.contains('static void resetInstance()');
              },
              'contains expected interface and concrete class declarations',
            ),
          },
        );
      },
    );

    test(
      'should report error when class name does not start with underscore',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/error_no_underscore.dart': await File(
            'test/src/error_no_underscore.dart',
          ).readAsString(),
        };
        final logs = <LogRecord>[];
        await testBuilder(
          builder,
          sourceAssets,
          rootPackage: 'my_package',
          onLog: logs.add,
        );
        expect(
          logs.map((l) => l.message),
          contains(contains('must start with an underscore')),
        );
      },
    );

    test(
      'should report error for unsupported field types',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/error_unsupported_type.dart': await File(
            'test/src/error_unsupported_type.dart',
          ).readAsString(),
        };
        final logs = <LogRecord>[];
        await testBuilder(
          builder,
          sourceAssets,
          rootPackage: 'my_package',
          onLog: logs.add,
        );
        expect(
          logs.map((l) => l.message),
          contains(contains('unsupported type')),
        );
      },
    );
  });
}

/// Resolves the path to a package in the pub cache via the workspace's
/// .dart_tool/package_config.json.
Future<String> _findPackagePath(String packageName) async {
  // Walk up to find the workspace root's package_config.json.
  var dir = Directory.current;
  while (true) {
    final configFile = File('${dir.path}/.dart_tool/package_config.json');
    if (configFile.existsSync()) {
      final content = await configFile.readAsString();
      final regex = RegExp('"name":\\s*"$packageName"[^}]*"rootUri":\\s*"([^"]+)"');
      final match = regex.firstMatch(content);
      if (match != null) {
        final rootUri = match.group(1)!;
        if (rootUri.startsWith('file://')) {
          return Uri.parse(rootUri).toFilePath();
        }
        // Relative path from .dart_tool/
        return '${dir.path}/.dart_tool/$rootUri';
      }
    }
    final parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  throw StateError('Could not find package "$packageName" in any package_config.json');
}
