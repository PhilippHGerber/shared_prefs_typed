// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.
// ignore_for_file: unused_element, unused_field

import 'package:shared_preferences/shared_preferences.dart';

import 'non_const_field_case.dart';

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await MixedFieldsPrefs.init()` on startup,
/// then access values via the singleton `MixedFieldsPrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `MixedFieldsPrefs(backend)`.
class MixedFieldsPrefs {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  const MixedFieldsPrefs(this._prefs);

  static MixedFieldsPrefs? _instance;

  static Future<MixedFieldsPrefs>? _initFuture;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static MixedFieldsPrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'MixedFieldsPrefs has not been initialized. '
        'Call `await MixedFieldsPrefs.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<MixedFieldsPrefs> init() {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit();
  }

  static Future<MixedFieldsPrefs> _doInit() async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = MixedFieldsPrefs(prefs);
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

  /// Gets the value for `constField` from the cache.
  ///
  /// If the key does not exist, the default value `100` is returned.
  int get constField {
    try {
      return _prefs.getInt('constField') ?? 100;
    } catch (_) {
      return 100;
    }
  }

  /// Asynchronously sets the value for `constField`.
  Future<void> setConstField(int value) {
    return _prefs.setInt('constField', value);
  }

  /// Checks if a value has been explicitly set for `constField`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetConstField() {
    return _prefs.containsKey('constField');
  }

  /// Removes the stored value for `constField`.
  ///
  /// After calling this, the getter will return the default value (`100`).
  Future<void> removeConstField() {
    return _prefs.remove('constField');
  }
}
