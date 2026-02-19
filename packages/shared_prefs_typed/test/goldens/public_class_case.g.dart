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

import 'public_class_case.dart';

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await AppPreferencesImpl.init()` on startup,
/// then access values via the singleton `AppPreferencesImpl.instance`.
///
/// **DI & Testing**: inject a backend directly: `AppPreferencesImpl(backend)`.
class AppPreferencesImpl {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  AppPreferencesImpl(
    this._prefs, {
    void Function(String key, Object error)? onReadError,
  }) : _onReadError = onReadError;

  static AppPreferencesImpl? _instance;

  static Future<AppPreferencesImpl>? _initFuture;

  /// Optional callback invoked when a stored value cannot be cast to its
  /// expected type (e.g. after a field type change between app versions).
  ///
  /// Receives the preference key and the exception. Use this to forward
  /// errors to a crash reporter (Crashlytics, Sentry, etc.).
  final void Function(String key, Object error)? _onReadError;

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
  static Future<AppPreferencesImpl> init({
    void Function(String key, Object error)? onReadError,
  }) {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit(onReadError: onReadError);
  }

  static Future<AppPreferencesImpl> _doInit({
    void Function(String key, Object error)? onReadError,
  }) async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = AppPreferencesImpl(prefs, onReadError: onReadError);
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

  /// Gets the value for `counter` from the cache.
  ///
  /// If the key does not exist, the default value `0` is returned.
  int get counter {
    try {
      return _prefs.getInt('counter') ?? 0;
    } catch (e) {
      log(
        '[shared_prefs_typed] Failed to read "counter": ${e.runtimeType}. Default will be used.',
        name: 'shared_prefs_typed',
      );
      _onReadError?.call('counter', e);
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
  bool containsCounter() {
    return _prefs.containsKey('counter');
  }

  /// Removes the stored value for `counter`.
  ///
  /// After calling this, the getter will return the default value (`0`).
  Future<void> removeCounter() {
    return _prefs.remove('counter');
  }

  /// Removes all preferences managed by this class from storage.
  ///
  /// After calling this, all getters return their default values.
  ///
  /// **Note:** This operation is not atomic. Concurrent writes during this
  /// operation may result in keys remaining in storage.
  Future<void> clearAll() {
    return Future.wait([_prefs.remove('counter')]);
  }
}
