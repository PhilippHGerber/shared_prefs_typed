// ignore_for_file: unused_element, unused_field // This file is used for code generation and may contain unused elements or fields.

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'pref_key_case.g.dart';

@TypedPrefs()
abstract class _PrefKeyPrefs {
  @PrefKey('legacy_counter')
  static const int counter = 0;
  static const String name = 'anon';
  @PrefKey('usr_dark_mode')
  static const bool isDarkMode = false;
}
