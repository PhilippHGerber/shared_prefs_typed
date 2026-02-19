// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.
// ignore_for_file: unused_element, unused_field

import 'package:shared_preferences/shared_preferences.dart';

import 'async_preferences.dart';

/// Provides type-safe, asynchronous access to application preferences.
///
/// **Simple apps**: call `await AsyncPreferencesImpl.init()` on startup,
/// then access values via the singleton `AsyncPreferencesImpl.instance`.
///
/// **DI & Testing**: inject a backend directly: `AsyncPreferencesImpl(backend)`.
class AsyncPreferencesImpl {
  /// Creates an instance backed by the given [SharedPreferencesAsync].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  AsyncPreferencesImpl(this._prefs);

  static AsyncPreferencesImpl? _instance;

  static Future<AsyncPreferencesImpl>? _initFuture;

  final SharedPreferencesAsync _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static AsyncPreferencesImpl get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'AsyncPreferencesImpl has not been initialized. '
        'Call `await AsyncPreferencesImpl.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<AsyncPreferencesImpl> init() {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit();
  }

  static Future<AsyncPreferencesImpl> _doInit() {
    return Future.value(
      _instance = AsyncPreferencesImpl(SharedPreferencesAsync()),
    );
  }

  /// Resets the singleton instance to `null`. Useful for test teardown.
  static void resetInstance() {
    _instance = null;
    _initFuture = null;
  }

  /// Asynchronously gets the value for `pingCount`.
  ///
  /// If the key does not exist, the default value `0` is returned.
  Future<int> get pingCount async {
    try {
      return (await _prefs.getInt('pingCount')) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// Asynchronously sets the value for `pingCount`.
  Future<void> setPingCount(int value) {
    return _prefs.setInt('pingCount', value);
  }

  /// Checks if a value has been explicitly set for `pingCount`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  Future<bool> isSetPingCount() {
    return _prefs.containsKey('pingCount');
  }

  /// Removes the stored value for `pingCount`.
  ///
  /// After calling this, the getter will return the default value (`0`).
  Future<void> removePingCount() {
    return _prefs.remove('pingCount');
  }

  /// Asynchronously gets the value for `serverId`.
  ///
  /// If the key does not exist, the default value `null` is returned.
  Future<String?> get serverId async {
    try {
      return (await _prefs.getString('serverId'));
    } catch (_) {
      return null;
    }
  }

  /// Asynchronously sets the value for `serverId`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setServerId(String? value) {
    if (value == null) {
      return _prefs.remove('serverId');
    }
    return _prefs.setString('serverId', value);
  }

  /// Checks if a value has been explicitly set for `serverId`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  Future<bool> isSetServerId() {
    return _prefs.containsKey('serverId');
  }

  /// Removes the stored value for `serverId`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeServerId() {
    return _prefs.remove('serverId');
  }

  /// Asynchronously gets the value for `isCacheEnabled`.
  ///
  /// If the key does not exist, the default value `true` is returned.
  Future<bool> get isCacheEnabled async {
    try {
      return (await _prefs.getBool('isCacheEnabled')) ?? true;
    } catch (_) {
      return true;
    }
  }

  /// Asynchronously sets the value for `isCacheEnabled`.
  Future<void> setIsCacheEnabled(bool value) {
    return _prefs.setBool('isCacheEnabled', value);
  }

  /// Checks if a value has been explicitly set for `isCacheEnabled`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  Future<bool> isSetIsCacheEnabled() {
    return _prefs.containsKey('isCacheEnabled');
  }

  /// Removes the stored value for `isCacheEnabled`.
  ///
  /// After calling this, the getter will return the default value (`true`).
  Future<void> removeIsCacheEnabled() {
    return _prefs.remove('isCacheEnabled');
  }
}
