// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.
// ignore_for_file: unused_element, unused_field

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'empty_class_case.dart';

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await EmptyPrefs.init()` on startup,
/// then access values via the singleton `EmptyPrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `EmptyPrefs(backend)`.
class EmptyPrefs {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  EmptyPrefs(this._prefs);

  static EmptyPrefs? _instance;

  static Future<EmptyPrefs>? _initFuture;

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
  static EmptyPrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'EmptyPrefs has not been initialized. '
        'Call `await EmptyPrefs.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<EmptyPrefs> init() {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit();
  }

  static Future<EmptyPrefs> _doInit() async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = EmptyPrefs(prefs);
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

  /// Removes all preferences managed by this class from storage.
  ///
  /// After calling this, all getters return their default values.
  Future<void> clearAll() {
    return Future.value();
  }
}
