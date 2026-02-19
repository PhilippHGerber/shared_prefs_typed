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

import 'date_time_iso_case.dart';

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await DateTimeIsoPrefs.init()` on startup,
/// then access values via the singleton `DateTimeIsoPrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `DateTimeIsoPrefs(backend)`.
class DateTimeIsoPrefs {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  DateTimeIsoPrefs(
    this._prefs, {
    void Function(String key, Object error)? onReadError,
  }) : _onReadError = onReadError;

  static DateTimeIsoPrefs? _instance;

  static Future<DateTimeIsoPrefs>? _initFuture;

  /// Optional callback invoked when a stored value cannot be cast to its
  /// expected type (e.g. after a field type change between app versions).
  ///
  /// Receives the preference key and the exception. Use this to forward
  /// errors to a crash reporter (Crashlytics, Sentry, etc.).
  final void Function(String key, Object error)? _onReadError;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static DateTimeIsoPrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'DateTimeIsoPrefs has not been initialized. '
        'Call `await DateTimeIsoPrefs.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<DateTimeIsoPrefs> init({
    void Function(String key, Object error)? onReadError,
  }) {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit(onReadError: onReadError);
  }

  static Future<DateTimeIsoPrefs> _doInit({
    void Function(String key, Object error)? onReadError,
  }) async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = DateTimeIsoPrefs(prefs, onReadError: onReadError);
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

  /// Gets the value for `lastLogin` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  DateTime? get lastLogin {
    final raw = _prefs.getString('lastLogin');
    if (raw == null) return null;
    try {
      return DateTime.parse(raw);
    } catch (e) {
      log(
        '[shared_prefs_typed] Failed to read "lastLogin": ${e.runtimeType}. Default will be used.',
        name: 'shared_prefs_typed',
      );
      _onReadError?.call('lastLogin', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `lastLogin`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setLastLogin(DateTime? value) {
    if (value == null) {
      return _prefs.remove('lastLogin');
    }
    return _prefs.setString('lastLogin', value.toIso8601String());
  }

  /// Checks if a value has been explicitly set for `lastLogin`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsLastLogin() {
    return _prefs.containsKey('lastLogin');
  }

  /// Removes the stored value for `lastLogin`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeLastLogin() {
    return _prefs.remove('lastLogin');
  }

  /// Gets the value for `updatedAt` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  DateTime? get updatedAt {
    final raw = _prefs.getString('updatedAt');
    if (raw == null) return null;
    try {
      return DateTime.parse(raw);
    } catch (e) {
      log(
        '[shared_prefs_typed] Failed to read "updatedAt": ${e.runtimeType}. Default will be used.',
        name: 'shared_prefs_typed',
      );
      _onReadError?.call('updatedAt', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `updatedAt`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setUpdatedAt(DateTime? value) {
    if (value == null) {
      return _prefs.remove('updatedAt');
    }
    return _prefs.setString('updatedAt', value.toIso8601String());
  }

  /// Checks if a value has been explicitly set for `updatedAt`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsUpdatedAt() {
    return _prefs.containsKey('updatedAt');
  }

  /// Removes the stored value for `updatedAt`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeUpdatedAt() {
    return _prefs.remove('updatedAt');
  }

  /// Removes all preferences managed by this class from storage.
  ///
  /// After calling this, all getters return their default values.
  Future<void> clearAll() {
    return Future.wait([
      _prefs.remove('lastLogin'),
      _prefs.remove('updatedAt'),
    ]);
  }
}
