// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.
// ignore_for_file: unused_element, unused_field

import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'async_case.dart';

/// Provides type-safe, asynchronous access to application preferences.
///
/// **Simple apps**: call `await AsyncPrefs.init()` on startup,
/// then access values via the singleton `AsyncPrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `AsyncPrefs(backend)`.
class AsyncPrefs {
  /// Creates an instance backed by the given [SharedPreferencesAsync].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  AsyncPrefs(this._prefs);

  static AsyncPrefs? _instance;

  static Future<AsyncPrefs>? _initFuture;

  /// Optional callback invoked when a stored value cannot be cast to its
  /// expected type (e.g. after a field type change between app versions).
  ///
  /// Receives the preference key and the exception. Use this to forward
  /// errors to a crash reporter (Crashlytics, Sentry, etc.).
  ///
  /// Set to `null` (the default) to disable.
  static void Function(String key, Object error)? onReadError;

  final SharedPreferencesAsync _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static AsyncPrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'AsyncPrefs has not been initialized. '
        'Call `await AsyncPrefs.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<AsyncPrefs> init() {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit();
  }

  static Future<AsyncPrefs> _doInit() {
    return Future.value(_instance = AsyncPrefs(SharedPreferencesAsync()));
  }

  /// Resets the singleton instance to `null`. Useful for test teardown.
  @visibleForTesting
  static void resetInstance() {
    _instance = null;
    _initFuture = null;
  }

  /// Asynchronously gets the value for `testInt`.
  ///
  /// If the key does not exist, the default value `10` is returned.
  Future<int> get testInt async {
    try {
      return (await _prefs.getInt('testInt')) ?? 10;
    } catch (e) {
      log(
        '[shared_prefs_typed] Failed to read "testInt": ${e.runtimeType}. Default will be used.',
        name: 'shared_prefs_typed',
      );
      onReadError?.call('testInt', e);
      return 10;
    }
  }

  /// Asynchronously sets the value for `testInt`.
  Future<void> setTestInt(int value) {
    return _prefs.setInt('testInt', value);
  }

  /// Checks if a value has been explicitly set for `testInt`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  Future<bool> containsTestInt() {
    return _prefs.containsKey('testInt');
  }

  /// Removes the stored value for `testInt`.
  ///
  /// After calling this, the getter will return the default value (`10`).
  Future<void> removeTestInt() {
    return _prefs.remove('testInt');
  }

  /// Asynchronously gets the value for `testNullableString`.
  ///
  /// If the key does not exist, the default value `null` is returned.
  Future<String?> get testNullableString async {
    try {
      return (await _prefs.getString('testNullableString'));
    } catch (e) {
      log(
        '[shared_prefs_typed] Failed to read "testNullableString": ${e.runtimeType}. Default will be used.',
        name: 'shared_prefs_typed',
      );
      onReadError?.call('testNullableString', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `testNullableString`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setTestNullableString(String? value) {
    if (value == null) {
      return _prefs.remove('testNullableString');
    }
    return _prefs.setString('testNullableString', value);
  }

  /// Checks if a value has been explicitly set for `testNullableString`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  Future<bool> containsTestNullableString() {
    return _prefs.containsKey('testNullableString');
  }

  /// Removes the stored value for `testNullableString`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeTestNullableString() {
    return _prefs.remove('testNullableString');
  }

  /// Asynchronously gets the value for `testBool`.
  ///
  /// If the key does not exist, the default value `true` is returned.
  Future<bool> get testBool async {
    try {
      return (await _prefs.getBool('testBool')) ?? true;
    } catch (e) {
      log(
        '[shared_prefs_typed] Failed to read "testBool": ${e.runtimeType}. Default will be used.',
        name: 'shared_prefs_typed',
      );
      onReadError?.call('testBool', e);
      return true;
    }
  }

  /// Asynchronously sets the value for `testBool`.
  Future<void> setTestBool(bool value) {
    return _prefs.setBool('testBool', value);
  }

  /// Checks if a value has been explicitly set for `testBool`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  Future<bool> containsTestBool() {
    return _prefs.containsKey('testBool');
  }

  /// Removes the stored value for `testBool`.
  ///
  /// After calling this, the getter will return the default value (`true`).
  Future<void> removeTestBool() {
    return _prefs.remove('testBool');
  }

  /// Removes all preferences managed by this class from storage.
  ///
  /// After calling this, all getters return their default values.
  Future<void> clearAll() {
    return Future.wait([
      _prefs.remove('testInt'),
      _prefs.remove('testNullableString'),
      _prefs.remove('testBool'),
    ]);
  }
}
