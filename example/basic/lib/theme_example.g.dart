// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.
// ignore_for_file: unused_element, unused_field

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_example.dart';

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await SettingsPrefsImpl.init()` on startup,
/// then access values via the singleton `SettingsPrefsImpl.instance`.
///
/// **DI & Testing**: inject a backend directly: `SettingsPrefsImpl(backend)`.
class SettingsPrefsImpl {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  SettingsPrefsImpl(this._prefs);

  static SettingsPrefsImpl? _instance;

  static Future<SettingsPrefsImpl>? _initFuture;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static SettingsPrefsImpl get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'SettingsPrefsImpl has not been initialized. '
        'Call `await SettingsPrefsImpl.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<SettingsPrefsImpl> init() {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit();
  }

  static Future<SettingsPrefsImpl> _doInit() async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = SettingsPrefsImpl(prefs);
    } catch (e) {
      _initFuture = null;
      rethrow;
    }
  }

  /// Resets the singleton instance to `null`. Useful for test teardown.
  @visibleForTesting
  static void resetInstance() {
    _instance = null;
    _initFuture = null;
  }

  /// Gets the value for `isLight` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  bool? get isLight {
    try {
      return _prefs.getBool('isLight');
    } catch (_) {
      return null;
    }
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
  bool containsIsLight() {
    return _prefs.containsKey('isLight');
  }

  /// Removes the stored value for `isLight`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeIsLight() {
    return _prefs.remove('isLight');
  }
}
