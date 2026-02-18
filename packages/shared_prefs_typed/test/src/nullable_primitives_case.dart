// This file is used as test input for code generation.
// ignore_for_file: unused_element, unused_field

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

// Tests that nullable primitive types (int?, double?, bool?) and an empty
// List<String> default produce correct generated code. These types are
// supported but not covered by success_case.dart.
@TypedPrefs()
abstract class _NullablePrefs {
  static const int? nullableInt = null;
  static const double? nullableDouble = null;
  static const bool? nullableBool = null;
  static const List<String> emptyStringList = <String>[];
}
