// This file is used as test input for code generation.
// ignore_for_file: directives_ordering, unused_import, unused_element, unused_field

import 'dart:developer';

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'async_case.g.dart';

@TypedPrefs(mode: PrefsMode.async)
abstract class _AsyncPrefs {
  static const int testInt = 10;
  static const String? testNullableString = null;
  static const bool testBool = true;
}
