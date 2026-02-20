// This file is used as test input for code generation.
// ignore_for_file: unused_element, unused_field

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'field_naming_case.g.dart';

// Tests edge cases in field naming:
// - Fields starting with '_' have the leading underscore stripped from the key
//   name (e.g. _underscoreField → key 'underscoreField').
// - Single-character field names (e.g. 'a') are handled without error.
@TypedPrefs()
abstract class _FieldNamingPrefs {
  static const int _underscoreField = 5;
  static const bool a = false;
}
