// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.
// ignore_for_file: unused_element, unused_field

import 'package:shared_preferences/shared_preferences.dart';

import 'app_preferences.dart';

/// Abstract interface for [AppPreferencesImpl].
///
/// Implement or mock this for dependency injection and testing.
abstract class AppPreferencesBase {
  int get counter;
  Future<void> setCounter(int value);
  bool isSetCounter();
  Future<void> removeCounter();
  bool get isDarkMode;
  Future<void> setIsDarkMode(bool value);
  bool isSetIsDarkMode();
  Future<void> removeIsDarkMode();
  String? get username;
  Future<void> setUsername(String? value);
  bool isSetUsername();
  Future<void> removeUsername();
}

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await AppPreferencesImpl.init()` on startup,
/// then access values via the singleton `AppPreferencesImpl.instance`.
///
/// **DI & Testing**: inject a backend directly: `AppPreferencesImpl(backend)`.
class AppPreferencesImpl implements AppPreferencesBase {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  const AppPreferencesImpl(this._prefs);

  static AppPreferencesImpl? _instance;

  static Future<AppPreferencesImpl>? _initFuture;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static AppPreferencesImpl get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'AppPreferencesImpl has not been initialized. '
        'Call `await AppPreferencesImpl.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<AppPreferencesImpl> init() {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit();
  }

  static Future<AppPreferencesImpl> _doInit() async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = AppPreferencesImpl(prefs);
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

  /// Gets the value for `counter` from the cache.
  ///
  /// If the key does not exist, the default value `0` is returned.
  int get counter {
    try {
      return _prefs.getInt('counter') ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// Asynchronously sets the value for `counter`.
  Future<void> setCounter(int value) {
    return _prefs.setInt('counter', value);
  }

  /// Checks if a value has been explicitly set for `counter`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetCounter() {
    return _prefs.containsKey('counter');
  }

  /// Removes the stored value for `counter`.
  ///
  /// After calling this, the getter will return the default value (`0`).
  Future<void> removeCounter() {
    return _prefs.remove('counter');
  }

  /// Gets the value for `isDarkMode` from the cache.
  ///
  /// If the key does not exist, the default value `false` is returned.
  bool get isDarkMode {
    try {
      return _prefs.getBool('isDarkMode') ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Asynchronously sets the value for `isDarkMode`.
  Future<void> setIsDarkMode(bool value) {
    return _prefs.setBool('isDarkMode', value);
  }

  /// Checks if a value has been explicitly set for `isDarkMode`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetIsDarkMode() {
    return _prefs.containsKey('isDarkMode');
  }

  /// Removes the stored value for `isDarkMode`.
  ///
  /// After calling this, the getter will return the default value (`false`).
  Future<void> removeIsDarkMode() {
    return _prefs.remove('isDarkMode');
  }

  /// Gets the value for `username` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  String? get username {
    try {
      return _prefs.getString('username');
    } catch (_) {
      return null;
    }
  }

  /// Asynchronously sets the value for `username`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setUsername(String? value) {
    if (value == null) {
      return _prefs.remove('username');
    }
    return _prefs.setString('username', value);
  }

  /// Checks if a value has been explicitly set for `username`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetUsername() {
    return _prefs.containsKey('username');
  }

  /// Removes the stored value for `username`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeUsername() {
    return _prefs.remove('username');
  }
}
