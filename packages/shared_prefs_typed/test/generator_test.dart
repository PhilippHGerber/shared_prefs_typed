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
    'shared_prefs_typed_annotations|lib/src/pref_key.dart': await File(
      '../shared_prefs_typed_annotations/lib/src/pref_key.dart',
    ).readAsString(),
    'shared_prefs_typed_annotations|lib/src/pref_date_time.dart': await File(
      '../shared_prefs_typed_annotations/lib/src/pref_date_time.dart',
    ).readAsString(),
    'shared_prefs_typed_annotations|lib/src/prefs_mode.dart': await File(
      '../shared_prefs_typed_annotations/lib/src/prefs_mode.dart',
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
      'should generate correct code for List<int> and List<double> types',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/numeric_list_case.dart': await File(
            'test/src/numeric_list_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/numeric_list_case.g.dart': await File(
            'test/goldens/numeric_list_case.g.dart',
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
      'should generate correct code for List<Enum> types',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/enum_list_case.dart': await File(
            'test/src/enum_list_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/enum_list_case.g.dart': await File(
            'test/goldens/enum_list_case.g.dart',
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
      'should generate correct code for List<bool> types',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/bool_list_case.dart': await File(
            'test/src/bool_list_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/bool_list_case.g.dart': await File(
            'test/goldens/bool_list_case.g.dart',
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
      'should generate correct code for nullable primitive types (int?, double?, bool?) '
      'and empty List<String> default',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/nullable_primitives_case.dart': await File(
            'test/src/nullable_primitives_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/nullable_primitives_case.g.dart': await File(
            'test/goldens/nullable_primitives_case.g.dart',
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
      'should generate non-nullable getters and nullable setters for nullable fields '
      'with non-null defaults',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/nullable_with_default_case.dart': await File(
            'test/src/nullable_with_default_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/nullable_with_default_case.g.dart': await File(
            'test/goldens/nullable_with_default_case.g.dart',
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
      'should correctly escape special characters in string default values',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/string_escaping_case.dart': await File(
            'test/src/string_escaping_case.dart',
          ).readAsString(),
        };
        await testBuilder(
          builder,
          sourceAssets,
          rootPackage: 'my_package',
          outputs: {
            'my_package|lib/string_escaping_case.g.dart': predicate<List<int>>(
              (bytes) {
                final content = utf8.decode(bytes);
                // Backslash is doubled: path\to\file → 'path\\to\\file'
                final hasBackslash =
                    content.contains(r"'path\\to\\file'") || content.contains(r'"path\\to\\file"');
                // Dollar sign is escaped: cost is $10 → 'cost is \$10'
                final hasDollar =
                    content.contains(r"'cost is \$10'") || content.contains(r'"cost is \$10"');
                // Actual newline char is represented as \n escape sequence
                final hasNewline =
                    content.contains(r"'line1\nline2'") || content.contains(r'"line1\nline2"');
                // Actual tab char is represented as \t escape sequence
                final hasTab =
                    content.contains(r"'col1\tcol2'") || content.contains(r'"col1\tcol2"');
                // Single quote is escaped or string uses double quotes
                final hasSingleQuote =
                    content.contains(r"it\'s here") || content.contains("it's here");
                // ${...} interpolation is escaped: Hello ${world} → Hello \${world}
                final hasInterpolation = content.contains(r'\${world}');
                return hasBackslash &&
                    hasDollar &&
                    hasNewline &&
                    hasTab &&
                    hasSingleQuote &&
                    hasInterpolation;
              },
              'contains correctly escaped string default values',
            ),
          },
        );
      },
    );

    test(
      'should strip leading underscore from field name and handle single-char field names',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/field_naming_case.dart': await File(
            'test/src/field_naming_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/field_naming_case.g.dart': await File(
            'test/goldens/field_naming_case.g.dart',
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
      'should generate a valid singleton class for a class with no fields',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/empty_class_case.dart': await File(
            'test/src/empty_class_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/empty_class_case.g.dart': await File(
            'test/goldens/empty_class_case.g.dart',
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
      'should generate abstract interface and concrete class when generateInterface is true',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/interface_case.dart': await File(
            'test/src/interface_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/interface_case.g.dart': await File(
            'test/goldens/interface_case.g.dart',
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
      'should silently ignore non-const fields and only generate methods for static const fields',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/non_const_field_case.dart': await File(
            'test/src/non_const_field_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/non_const_field_case.g.dart': await File(
            'test/goldens/non_const_field_case.g.dart',
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
      'should generate correct code combining async mode and generateInterface',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/async_interface_case.dart': await File(
            'test/src/async_interface_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/async_interface_case.g.dart': await File(
            'test/goldens/async_interface_case.g.dart',
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
      'should use @PrefKey value as storage key while keeping field-derived API names',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/pref_key_case.dart': await File(
            'test/src/pref_key_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/pref_key_case.g.dart': await File(
            'test/goldens/pref_key_case.g.dart',
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
      'should report error for duplicate SharedPreferences keys',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/error_duplicate_pref_key.dart': await File(
            'test/src/error_duplicate_pref_key.dart',
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
          contains(contains('Duplicate SharedPreferences key')),
        );
      },
    );

    test(
      'should report error when @TypedPrefs is used on a non-class element',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/error_on_function.dart': await File(
            'test/src/error_on_function.dart',
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
          contains(contains('can only be used on classes')),
        );
      },
    );

    test(
      'should report error when shared_preferences import is missing',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/error_missing_import.dart': await File(
            'test/src/error_missing_import.dart',
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
          contains(contains('Missing required import')),
        );
      },
    );

    test(
      'should report error when a field name conflicts with a built-in generated member',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/error_reserved_name.dart': await File(
            'test/src/error_reserved_name.dart',
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
          contains(contains('produces a generated API name')),
        );
      },
    );

    test(
      'should generate a class with Impl suffix for public (non-underscore) class names',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/public_class_case.dart': await File(
            'test/src/public_class_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/public_class_case.g.dart': await File(
            'test/goldens/public_class_case.g.dart',
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
      'should generate correct code for enum types',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/enum_case.dart': await File(
            'test/src/enum_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/enum_case.g.dart': await File(
            'test/goldens/enum_case.g.dart',
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
      'should generate correct code for DateTime with millisecondsSinceEpoch encoding',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/date_time_millis_case.dart': await File(
            'test/src/date_time_millis_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/date_time_millis_case.g.dart': await File(
            'test/goldens/date_time_millis_case.g.dart',
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
      'should generate correct code for DateTime with iso8601 encoding',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/date_time_iso_case.dart': await File(
            'test/src/date_time_iso_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/date_time_iso_case.g.dart': await File(
            'test/goldens/date_time_iso_case.g.dart',
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
      'should generate correct code for non-nullable DateTime with millisecondsSinceEpoch encoding',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/date_time_non_null_millis_case.dart': await File(
            'test/src/date_time_non_null_millis_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/date_time_non_null_millis_case.g.dart': await File(
            'test/goldens/date_time_non_null_millis_case.g.dart',
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
      'should generate correct code for non-nullable DateTime with iso8601 encoding',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/date_time_non_null_iso_case.dart': await File(
            'test/src/date_time_non_null_iso_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/date_time_non_null_iso_case.g.dart': await File(
            'test/goldens/date_time_non_null_iso_case.g.dart',
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
      'should generate correct code for async DateTime with iso8601 encoding',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/async_date_time_iso_case.dart': await File(
            'test/src/async_date_time_iso_case.dart',
          ).readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/async_date_time_iso_case.g.dart': await File(
            'test/goldens/async_date_time_iso_case.g.dart',
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
      'should report error for DateTime field without @PrefDateTime annotation',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/error_date_time_no_annotation.dart': await File(
            'test/src/error_date_time_no_annotation.dart',
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
          contains(contains('has no @PrefDateTime annotation')),
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
