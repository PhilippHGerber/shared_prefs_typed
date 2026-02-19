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

import 'date_time_non_null_iso_case.dart';

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await DateTimeNonNullIsoPrefs.init()` on startup,
/// then access values via the singleton `DateTimeNonNullIsoPrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `DateTimeNonNullIsoPrefs(backend)`.
class DateTimeNonNullIsoPrefs {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  DateTimeNonNullIsoPrefs(
    this._prefs, {
    void Function(String key, Object error)? onReadError,
  }) : _onReadError = onReadError;

  static DateTimeNonNullIsoPrefs? _instance;

  static Future<DateTimeNonNullIsoPrefs>? _initFuture;

  /// Optional callback invoked when a stored value cannot be cast to its
  /// expected type (e.g. after a field type change between app versions).
  ///
  /// Receives the preference key and the exception. Use this to forward
  /// errors to a crash reporter (Crashlytics, Sentry, etc.).
  final void Function(String key, Object error)? _onReadError;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static DateTimeNonNullIsoPrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'DateTimeNonNullIsoPrefs has not been initialized. '
        'Call `await DateTimeNonNullIsoPrefs.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<DateTimeNonNullIsoPrefs> init({
    void Function(String key, Object error)? onReadError,
  }) {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit(onReadError: onReadError);
  }

  static Future<DateTimeNonNullIsoPrefs> _doInit({
    void Function(String key, Object error)? onReadError,
  }) async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = DateTimeNonNullIsoPrefs(
        prefs,
        onReadError: onReadError,
      );
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

  /// Gets the value for `installDate` from the cache.
  ///
  /// If the key does not exist, the default value `DateTime.fromMillisecondsSinceEpoch(0)` is returned.
  DateTime get installDate {
    final raw = _prefs.getString('installDate');
    if (raw == null) return DateTime.fromMillisecondsSinceEpoch(0);
    try {
      return DateTime.parse(raw);
    } catch (e) {
      log(
        '[shared_prefs_typed] Failed to read "installDate": ${e.runtimeType}. Default will be used.',
        name: 'shared_prefs_typed',
      );
      _onReadError?.call('installDate', e);
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  /// Asynchronously sets the value for `installDate`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setInstallDate(DateTime? value) {
    if (value == null) {
      return _prefs.remove('installDate');
    }
    return _prefs.setString('installDate', value.toIso8601String());
  }

  /// Checks if a value has been explicitly set for `installDate`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsInstallDate() {
    return _prefs.containsKey('installDate');
  }

  /// Removes the stored value for `installDate`.
  ///
  /// After calling this, the getter will return the default value (`DateTime.fromMillisecondsSinceEpoch(0)`).
  Future<void> removeInstallDate() {
    return _prefs.remove('installDate');
  }

  /// Removes all preferences managed by this class from storage.
  ///
  /// After calling this, all getters return their default values.
  ///
  /// **Note:** This operation is not atomic. Concurrent writes during this
  /// operation may result in keys remaining in storage.
  Future<void> clearAll() {
    return Future.wait([_prefs.remove('installDate')]);
  }
}
