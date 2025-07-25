import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/shared_pref_generator.dart';

/// Builder factory for the `TypedPrefs` generator.
///
/// This uses a [LibraryBuilder] to generate a complete, standalone Dart file
/// with its own imports, eliminating the need for a 'part' directive.
Builder typedPrefsBuilder(BuilderOptions options) {
  // Use LibraryBuilder for standalone files.
  return LibraryBuilder(
    TypedPrefsGenerator(),
  );
}
