// This file is used as test input for code generation.
// ignore_for_file: unused_element, unused_field

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

// Tests that non-const static fields are silently ignored by the generator.
// Only the static const field should appear in the generated output.
@TypedPrefs()
abstract class _MixedFieldsPrefs {
  static const int constField = 100;
  static int notConst = 999;
}
