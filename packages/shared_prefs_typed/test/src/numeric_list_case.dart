// This file is used as test input for code generation.
// ignore_for_file: unused_element, unused_field

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

// Tests that List<int> and List<double> fields produce correct generated code,
// including transparent serialization to/from List<String> storage.
@TypedPrefs()
abstract class _NumericListPrefs {
  static const List<int> intList = [1, 2, 3];
  static const List<double> doubleList = [1.5, 2.5];
  static const List<int>? nullableIntList = null;
  static const List<double>? nullableDoubleList = null;
}
