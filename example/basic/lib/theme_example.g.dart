// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

// ignore_for_file: unused_element, unused_field

import 'package:shared_preferences/shared_preferences.dart';

import 'theme_example.dart';

/// Provides type-safe, cached access to application preferences.
///
/// Use `await SettingsPrefs.init()` on app startup,
/// then access values via the singleton `instance`,
/// or create an instance directly: `SettingsPrefs(prefs)`.
class SettingsPrefs {
  SettingsPrefs(this._prefs);

  static SettingsPrefs? _instance;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static SettingsPrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'SettingsPrefs has not been initialized. '
        'Call `await SettingsPrefs.init()` before accessing `instance`, '
        'or use the SettingsPrefs(prefs) constructor directly.',
      );
    }
    return i;
  }

  /// Initializes the preferences service.
  static Future<void> init() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    _instance = SettingsPrefs(prefs);
  }

  /// Resets the singleton instance to `null`. Useful for test teardown.
  static void resetInstance() {
    _instance = null;
  }

  /// Gets the value for `isLight` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  bool? get isLight {
    return _prefs.getBool('isLight');
  }

  /// Asynchronously sets the value for `isLight`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setIsLight(bool? value) {
    if (value == null) {
      return _prefs.remove('isLight');
    }
    return _prefs.setBool('isLight', value);
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
