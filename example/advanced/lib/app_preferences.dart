// This file is a code-generation source: the private class and its fields
// are intentionally unreferenced from production code.
// ignore_for_file: unused_element, unused_field
// Run `flutter pub run build_runner build` to regenerate app_preferences.g.dart.

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

/// Defines the preferences schema for the advanced get_it example.
///
/// `generateInterface: true` produces `AppPreferencesBase` — an abstract class
/// that can be registered in get_it and mocked in tests, so production code
/// never depends directly on the concrete generated class.
@TypedPrefs(generateInterface: true)
abstract class _AppPreferences {
  /// How many times the button has been pressed. Resets to 0 on clear.
  static const int counter = 0;

  /// Whether the app should use dark theme.
  static const bool isDarkMode = false;

  /// Optional display name. Null until the user sets one.
  static const String? username = null;
}
