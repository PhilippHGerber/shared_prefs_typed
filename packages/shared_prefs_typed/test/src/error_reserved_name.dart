// This file is used as test input for code generation.
// ignore_for_file: unused_element, unused_field

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

// Tests that a field whose name collides with a built-in generated member is rejected.
@TypedPrefs()
abstract class _ReservedNamePrefs {
  static const int init = 0;
}
