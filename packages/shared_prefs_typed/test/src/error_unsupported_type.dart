// This file is used as test input for error case validation.
// ignore_for_file: unused_element, unused_field

import 'dart:developer';

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

@TypedPrefs()
abstract class _BadPrefs {
  static const int counter = 0;
  static const Map<String, int> lookup = {};
}
