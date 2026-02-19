// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.
// ignore_for_file: unused_element, unused_field

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'date_time_non_null_millis_case.dart';

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await DateTimeNonNullMillisPrefs.init()` on startup,
/// then access values via the singleton `DateTimeNonNullMillisPrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `DateTimeNonNullMillisPrefs(backend)`.
class DateTimeNonNullMillisPrefs {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  DateTimeNonNullMillisPrefs(this._prefs);

  static DateTimeNonNullMillisPrefs? _instance;

  static Future<DateTimeNonNullMillisPrefs>? _initFuture;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static DateTimeNonNullMillisPrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'DateTimeNonNullMillisPrefs has not been initialized. '
        'Call `await DateTimeNonNullMillisPrefs.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<DateTimeNonNullMillisPrefs> init() {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit();
  }

  static Future<DateTimeNonNullMillisPrefs> _doInit() async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = DateTimeNonNullMillisPrefs(prefs);
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
    try {
      final raw = _prefs.getInt('installDate');
      if (raw == null) return DateTime.fromMillisecondsSinceEpoch(0);
      return DateTime.fromMillisecondsSinceEpoch(raw);
    } catch (_) {
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
    return _prefs.setInt('installDate', value.millisecondsSinceEpoch);
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
}
