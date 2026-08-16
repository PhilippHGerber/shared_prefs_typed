// This file is used as test input for code generation.
// ignore_for_file: unused_element, unused_field, unnecessary_nullable_for_final_variable_declarations

import 'dart:developer';

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'nullable_with_default_case.g.dart';

// Tests that nullable fields with non-null defaults produce non-nullable getters
// and nullable setters (the "reset to factory default" pattern).
@TypedPrefs()
abstract class _NullableWithDefaultPrefs {
  static const int? retryCount = 3;
  static const double? threshold = 0.5;
  static const bool? featureEnabled = true;
  static const String? greeting = 'Hello';
}
