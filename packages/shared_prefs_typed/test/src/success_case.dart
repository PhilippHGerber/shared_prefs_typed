// ignore_for_file: unused_element, unused_field // This file is used for code generation and may contain unused elements or fields.

import 'dart:developer';

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'success_case.g.dart';

@TypedPrefs()
abstract class _TestPrefs {
  static const int testInt = 10;
  static const double testDouble = 3.14;
  static const bool testBool = true;
  static const String testString = 'Hello';
  static const List<String> testStringList = ['a', 'b'];
  static const String? testNullableString = null;
}
