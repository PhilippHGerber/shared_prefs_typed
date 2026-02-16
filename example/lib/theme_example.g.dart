// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

// ignore_for_file: unnecessary_cast, unused_element, unused_field

import 'package:shared_preferences/shared_preferences.dart';

import 'theme_example.dart';

/// Provides type-safe, cached access to application preferences.
///
/// Use `await SettingsPrefs.init()` on app startup,
/// then access values via the singleton `instance`.
class SettingsPrefs {
  SettingsPrefs._();

  static final instance = SettingsPrefs._();

  static late SharedPreferencesWithCache _prefs;

  /// Initializes the preferences service.
  static Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
  }

  /// Gets the value for `isLight` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  bool? get isLight {
    return _prefs.getBool('isLight') ?? null;
  }

  /// Asynchronously sets the value for `isLight`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setIsLight(bool? value) {
    if (value == null) {
      return _prefs.remove('isLight');
    }
    return _prefs.setBool('isLight', value as bool);
  }

  /// Checks if a value has been explicitly set for `isLight`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetIsLight() {
    return _prefs.containsKey('isLight');
  }

  /// Removes the stored value for `isLight`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeIsLight() {
    return _prefs.remove('isLight');
  }
}
