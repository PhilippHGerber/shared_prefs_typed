// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.
// ignore_for_file: unused_element, unused_field

import 'package:shared_preferences/shared_preferences.dart';

import 'nullable_with_default_case.dart';

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await NullableWithDefaultPrefs.init()` on startup,
/// then access values via the singleton `NullableWithDefaultPrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `NullableWithDefaultPrefs(backend)`.
class NullableWithDefaultPrefs {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  const NullableWithDefaultPrefs(this._prefs);

  static NullableWithDefaultPrefs? _instance;

  static Future<NullableWithDefaultPrefs>? _initFuture;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static NullableWithDefaultPrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'NullableWithDefaultPrefs has not been initialized. '
        'Call `await NullableWithDefaultPrefs.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<NullableWithDefaultPrefs> init() {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit();
  }

  static Future<NullableWithDefaultPrefs> _doInit() async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = NullableWithDefaultPrefs(prefs);
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

  /// Gets the value for `retryCount` from the cache.
  ///
  /// If the key does not exist, the default value `3` is returned.
  int get retryCount {
    return _prefs.getInt('retryCount') ?? 3;
  }

  /// Asynchronously sets the value for `retryCount`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setRetryCount(int? value) {
    if (value == null) {
      return _prefs.remove('retryCount');
    }
    return _prefs.setInt('retryCount', value);
  }

  /// Checks if a value has been explicitly set for `retryCount`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetRetryCount() {
    return _prefs.containsKey('retryCount');
  }

  /// Removes the stored value for `retryCount`.
  ///
  /// After calling this, the getter will return the default value (`3`).
  Future<void> removeRetryCount() {
    return _prefs.remove('retryCount');
  }

  /// Gets the value for `threshold` from the cache.
  ///
  /// If the key does not exist, the default value `0.5` is returned.
  double get threshold {
    return _prefs.getDouble('threshold') ?? 0.5;
  }

  /// Asynchronously sets the value for `threshold`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setThreshold(double? value) {
    if (value == null) {
      return _prefs.remove('threshold');
    }
    return _prefs.setDouble('threshold', value);
  }

  /// Checks if a value has been explicitly set for `threshold`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetThreshold() {
    return _prefs.containsKey('threshold');
  }

  /// Removes the stored value for `threshold`.
  ///
  /// After calling this, the getter will return the default value (`0.5`).
  Future<void> removeThreshold() {
    return _prefs.remove('threshold');
  }

  /// Gets the value for `featureEnabled` from the cache.
  ///
  /// If the key does not exist, the default value `true` is returned.
  bool get featureEnabled {
    return _prefs.getBool('featureEnabled') ?? true;
  }

  /// Asynchronously sets the value for `featureEnabled`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setFeatureEnabled(bool? value) {
    if (value == null) {
      return _prefs.remove('featureEnabled');
    }
    return _prefs.setBool('featureEnabled', value);
  }

  /// Checks if a value has been explicitly set for `featureEnabled`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetFeatureEnabled() {
    return _prefs.containsKey('featureEnabled');
  }

  /// Removes the stored value for `featureEnabled`.
  ///
  /// After calling this, the getter will return the default value (`true`).
  Future<void> removeFeatureEnabled() {
    return _prefs.remove('featureEnabled');
  }

  /// Gets the value for `greeting` from the cache.
  ///
  /// If the key does not exist, the default value `'Hello'` is returned.
  String get greeting {
    return _prefs.getString('greeting') ?? 'Hello';
  }

  /// Asynchronously sets the value for `greeting`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setGreeting(String? value) {
    if (value == null) {
      return _prefs.remove('greeting');
    }
    return _prefs.setString('greeting', value);
  }

  /// Checks if a value has been explicitly set for `greeting`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetGreeting() {
    return _prefs.containsKey('greeting');
  }

  /// Removes the stored value for `greeting`.
  ///
  /// After calling this, the getter will return the default value (`'Hello'`).
  Future<void> removeGreeting() {
    return _prefs.remove('greeting');
  }
}
