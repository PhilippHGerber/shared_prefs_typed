import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:shared_prefs_typed/shared_prefs_typed.dart';
import 'package:test/test.dart';

void main() async {
  final commonAssets = {
    'shared_prefs_typed_annotations|lib/shared_prefs_typed_annotations.dart': await File(
      '../shared_prefs_typed_annotations/lib/shared_prefs_typed_annotations.dart',
    ).readAsString(),
  };

  group('TypedPrefsGenerator', () {
    final builder = typedPrefsBuilder(BuilderOptions.empty);

    // This successful test case is correct and remains unchanged.
    test(
      'should generate correct code for all supported types in sync mode',
      () async {
        final sourceAssets = {
          ...commonAssets,
          'my_package|lib/success_case.dart':
              await File('test/src/success_case.dart').readAsString(),
        };
        final expectedOutputs = {
          'my_package|lib/success_case.g.dart':
              await File('test/goldens/success_case.g.dart').readAsString(),
        };
        await testBuilder(
          builder,
          sourceAssets,
          outputs: expectedOutputs,
          rootPackage: 'my_package',
        );
      },
    );
  });
}
