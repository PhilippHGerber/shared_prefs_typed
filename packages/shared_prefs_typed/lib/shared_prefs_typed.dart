import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/shared_pref_generator.dart';

/// Builder factory for the `TypedPrefs` generator.
Builder typedPrefsBuilder(BuilderOptions options) {
  return PartBuilder(
    [TypedPrefsGenerator()],
    '.g.dart',
    header: '// GENERATED CODE - DO NOT MODIFY BY HAND\n',
  );
}
