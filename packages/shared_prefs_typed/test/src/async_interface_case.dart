// This file is used as test input for code generation.
// ignore_for_file: unused_element, unused_field

import 'dart:developer';

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'async_interface_case.g.dart';

// Tests that mode: PrefsMode.async and generateInterface: true can be combined,
// exercising the async branch of the interface getter return type (Future<T>).
@TypedPrefs(mode: PrefsMode.async, generateInterface: true)
abstract class _AsyncInterfacePrefs {
  static const String message = 'hello';
  static const int count = 0;
}
