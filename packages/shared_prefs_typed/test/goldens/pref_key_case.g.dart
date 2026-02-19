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

  /// Optional callback invoked when a stored value cannot be cast to its
  /// expected type (e.g. after a field type change between app versions).
  ///
  /// Receives the preference key and the exception. Use this to forward
  /// errors to a crash reporter (Crashlytics, Sentry, etc.).
  ///
  /// Set to `null` (the default) to disable.
  static void Function(String key, Object error)? onReadError;

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
  @visibleForTesting
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
    } catch (e) {
      log(
        '[shared_prefs_typed] Failed to read "legacy_counter": ${e.runtimeType}. Default will be used.',
        name: 'shared_prefs_typed',
      );
      onReadError?.call('legacy_counter', e);
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
  bool containsCounter() {
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
    } catch (e) {
      log(
        '[shared_prefs_typed] Failed to read "name": ${e.runtimeType}. Default will be used.',
        name: 'shared_prefs_typed',
      );
      onReadError?.call('name', e);
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
  bool containsName() {
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
    } catch (e) {
      log(
        '[shared_prefs_typed] Failed to read "usr_dark_mode": ${e.runtimeType}. Default will be used.',
        name: 'shared_prefs_typed',
      );
      onReadError?.call('usr_dark_mode', e);
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
  bool containsIsDarkMode() {
    return _prefs.containsKey('usr_dark_mode');
  }

  /// Removes the stored value for `usr_dark_mode`.
  ///
  /// After calling this, the getter will return the default value (`false`).
  Future<void> removeIsDarkMode() {
    return _prefs.remove('usr_dark_mode');
  }

  /// Removes all preferences managed by this class from storage.
  ///
  /// After calling this, all getters return their default values.
  Future<void> clearAll() {
    return Future.wait([
      _prefs.remove('legacy_counter'),
      _prefs.remove('name'),
      _prefs.remove('usr_dark_mode'),
    ]);
  }
}
