// Run `flutter pub run build_runner build` to regenerate app_preferences.g.dart.

import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

part 'app_preferences.g.dart';

/// Defines the preferences schema for the advanced get_it example.
///
/// `generateInterface: true` produces `AppPreferencesBase` — an abstract
/// class that can be registered in get_it and mocked in tests, so production
/// code never depends directly on the concrete generated class.
@TypedPrefs(generateInterface: true)
abstract class AppPreferences {
  /// How many times the button has been pressed. Resets to 0 on clear.
  static const int counter = 0;

  /// The app's theme mode, stored as the enum's `.name` string.
  static const ThemeMode themeMode = ThemeMode.system;

  /// Optional display name. Null until the user sets one.
  static const String? username = null;
}
