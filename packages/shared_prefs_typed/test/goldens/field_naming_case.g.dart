// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.
// ignore_for_file: unused_element, unused_field

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'field_naming_case.dart';

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await FieldNamingPrefs.init()` on startup,
/// then access values via the singleton `FieldNamingPrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `FieldNamingPrefs(backend)`.
class FieldNamingPrefs {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  FieldNamingPrefs(this._prefs);

  static FieldNamingPrefs? _instance;

  static Future<FieldNamingPrefs>? _initFuture;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static FieldNamingPrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'FieldNamingPrefs has not been initialized. '
        'Call `await FieldNamingPrefs.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<FieldNamingPrefs> init() {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit();
  }

  static Future<FieldNamingPrefs> _doInit() async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = FieldNamingPrefs(prefs);
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

  /// Gets the value for `underscoreField` from the cache.
  ///
  /// If the key does not exist, the default value `5` is returned.
  int get underscoreField {
    try {
      return _prefs.getInt('underscoreField') ?? 5;
    } catch (_) {
      return 5;
    }
  }

  /// Asynchronously sets the value for `underscoreField`.
  Future<void> setUnderscoreField(int value) {
    return _prefs.setInt('underscoreField', value);
  }

  /// Checks if a value has been explicitly set for `underscoreField`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetUnderscoreField() {
    return _prefs.containsKey('underscoreField');
  }

  /// Removes the stored value for `underscoreField`.
  ///
  /// After calling this, the getter will return the default value (`5`).
  Future<void> removeUnderscoreField() {
    return _prefs.remove('underscoreField');
  }

  /// Gets the value for `a` from the cache.
  ///
  /// If the key does not exist, the default value `false` is returned.
  bool get a {
    try {
      return _prefs.getBool('a') ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Asynchronously sets the value for `a`.
  Future<void> setA(bool value) {
    return _prefs.setBool('a', value);
  }

  /// Checks if a value has been explicitly set for `a`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetA() {
    return _prefs.containsKey('a');
  }

  /// Removes the stored value for `a`.
  ///
  /// After calling this, the getter will return the default value (`false`).
  Future<void> removeA() {
    return _prefs.remove('a');
  }
}
