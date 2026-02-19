// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.
// ignore_for_file: unused_element, unused_field

import 'package:shared_preferences/shared_preferences.dart';

import 'pref_key_case.dart';

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await PrefKeyPrefs.init()` on startup,
/// then access values via the singleton `PrefKeyPrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `PrefKeyPrefs(backend)`.
class PrefKeyPrefs {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  PrefKeyPrefs(this._prefs);

  static PrefKeyPrefs? _instance;

  static Future<PrefKeyPrefs>? _initFuture;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static PrefKeyPrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'PrefKeyPrefs has not been initialized. '
        'Call `await PrefKeyPrefs.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<PrefKeyPrefs> init() {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit();
  }

  static Future<PrefKeyPrefs> _doInit() async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = PrefKeyPrefs(prefs);
    } catch (e) {
      _initFuture = null;
      rethrow;
    }
  }

  /// Resets the singleton instance to `null`. Useful for test teardown.
  static void resetInstance() {
    _instance = null;
    _initFuture = null;
  }

  /// Gets the value for `legacy_counter` from the cache.
  ///
  /// If the key does not exist, the default value `0` is returned.
  int get counter {
    try {
      return _prefs.getInt('legacy_counter') ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// Asynchronously sets the value for `legacy_counter`.
  Future<void> setCounter(int value) {
    return _prefs.setInt('legacy_counter', value);
  }

  /// Checks if a value has been explicitly set for `legacy_counter`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetCounter() {
    return _prefs.containsKey('legacy_counter');
  }

  /// Removes the stored value for `legacy_counter`.
  ///
  /// After calling this, the getter will return the default value (`0`).
  Future<void> removeCounter() {
    return _prefs.remove('legacy_counter');
  }

  /// Gets the value for `name` from the cache.
  ///
  /// If the key does not exist, the default value `'anon'` is returned.
  String get name {
    try {
      return _prefs.getString('name') ?? 'anon';
    } catch (_) {
      return 'anon';
    }
  }

  /// Asynchronously sets the value for `name`.
  Future<void> setName(String value) {
    return _prefs.setString('name', value);
  }

  /// Checks if a value has been explicitly set for `name`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetName() {
    return _prefs.containsKey('name');
  }

  /// Removes the stored value for `name`.
  ///
  /// After calling this, the getter will return the default value (`'anon'`).
  Future<void> removeName() {
    return _prefs.remove('name');
  }

  /// Gets the value for `usr_dark_mode` from the cache.
  ///
  /// If the key does not exist, the default value `false` is returned.
  bool get isDarkMode {
    try {
      return _prefs.getBool('usr_dark_mode') ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Asynchronously sets the value for `usr_dark_mode`.
  Future<void> setIsDarkMode(bool value) {
    return _prefs.setBool('usr_dark_mode', value);
  }

  /// Checks if a value has been explicitly set for `usr_dark_mode`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetIsDarkMode() {
    return _prefs.containsKey('usr_dark_mode');
  }

  /// Removes the stored value for `usr_dark_mode`.
  ///
  /// After calling this, the getter will return the default value (`false`).
  Future<void> removeIsDarkMode() {
    return _prefs.remove('usr_dark_mode');
  }
}
