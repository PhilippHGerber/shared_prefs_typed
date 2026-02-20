// This file is used as test input for code generation.
// Tests that a public (non-underscore-prefixed) class produces a generated class
// with an 'Impl' suffix (AppPreferences → AppPreferencesImpl).

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'public_class_case.g.dart';

@TypedPrefs()
abstract class AppPreferences {
  static const int counter = 0;
}
