// This file is used as test input for code generation.
// ignore_for_file: unused_element, unused_field

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

@TypedPrefs(async: true)
abstract class _AsyncPrefs {
  static const int testInt = 10;
  static const String? testNullableString = null;
  static const bool testBool = true;
}
