// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.
// ignore_for_file: unused_element, unused_field

import 'dart:collection';
import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'nullable_primitives_case.dart';

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await NullablePrefs.init()` on startup,
/// then access values via the singleton `NullablePrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `NullablePrefs(backend)`.
class NullablePrefs {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  NullablePrefs(
    this._prefs, {
    void Function(String key, Object error)? onReadError,
  }) : _onReadError = onReadError;

  static NullablePrefs? _instance;

  static Future<NullablePrefs>? _initFuture;

  /// Optional callback invoked when a stored value cannot be cast to its
  /// expected type (e.g. after a field type change between app versions).
  ///
  /// Receives the preference key and the exception. Use this to forward
  /// errors to a crash reporter (Crashlytics, Sentry, etc.).
  final void Function(String key, Object error)? _onReadError;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static NullablePrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'NullablePrefs has not been initialized. '
        'Call `await NullablePrefs.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<NullablePrefs> init({
    void Function(String key, Object error)? onReadError,
  }) {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit(onReadError: onReadError);
  }

  static Future<NullablePrefs> _doInit({
    void Function(String key, Object error)? onReadError,
  }) async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = NullablePrefs(prefs, onReadError: onReadError);
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

  /// Gets the value for `nullableInt` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  int? get nullableInt {
    try {
      return _prefs.getInt('nullableInt');
    } catch (e) {
      log(
        '[shared_prefs_typed] Failed to read "nullableInt": ${e.runtimeType}. Default will be used.',
        name: 'shared_prefs_typed',
      );
      _onReadError?.call('nullableInt', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `nullableInt`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setNullableInt(int? value) {
    if (value == null) {
      return _prefs.remove('nullableInt');
    }
    return _prefs.setInt('nullableInt', value);
  }

  /// Checks if a value has been explicitly set for `nullableInt`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsNullableInt() {
    return _prefs.containsKey('nullableInt');
  }

  /// Removes the stored value for `nullableInt`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeNullableInt() {
    return _prefs.remove('nullableInt');
  }

  /// Gets the value for `nullableDouble` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  double? get nullableDouble {
    try {
      return _prefs.getDouble('nullableDouble');
    } catch (e) {
      log(
        '[shared_prefs_typed] Failed to read "nullableDouble": ${e.runtimeType}. Default will be used.',
        name: 'shared_prefs_typed',
      );
      _onReadError?.call('nullableDouble', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `nullableDouble`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setNullableDouble(double? value) {
    if (value == null) {
      return _prefs.remove('nullableDouble');
    }
    return _prefs.setDouble('nullableDouble', value);
  }

  /// Checks if a value has been explicitly set for `nullableDouble`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsNullableDouble() {
    return _prefs.containsKey('nullableDouble');
  }

  /// Removes the stored value for `nullableDouble`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeNullableDouble() {
    return _prefs.remove('nullableDouble');
  }

  /// Gets the value for `nullableBool` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  bool? get nullableBool {
    try {
      return _prefs.getBool('nullableBool');
    } catch (e) {
      log(
        '[shared_prefs_typed] Failed to read "nullableBool": ${e.runtimeType}. Default will be used.',
        name: 'shared_prefs_typed',
      );
      _onReadError?.call('nullableBool', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `nullableBool`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setNullableBool(bool? value) {
    if (value == null) {
      return _prefs.remove('nullableBool');
    }
    return _prefs.setBool('nullableBool', value);
  }

  /// Checks if a value has been explicitly set for `nullableBool`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsNullableBool() {
    return _prefs.containsKey('nullableBool');
  }

  /// Removes the stored value for `nullableBool`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeNullableBool() {
    return _prefs.remove('nullableBool');
  }

  /// Gets the value for `emptyStringList` from the cache.
  ///
  /// If the key does not exist, the default value `const <String>[]` is returned.
  List<String> get emptyStringList {
    final raw = _prefs.getStringList('emptyStringList');
    return raw == null ? const <String>[] : UnmodifiableListView(raw);
  }

  /// Asynchronously sets the value for `emptyStringList`.
  Future<void> setEmptyStringList(List<String> value) {
    return _prefs.setStringList('emptyStringList', value);
  }

  /// Checks if a value has been explicitly set for `emptyStringList`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsEmptyStringList() {
    return _prefs.containsKey('emptyStringList');
  }

  /// Removes the stored value for `emptyStringList`.
  ///
  /// After calling this, the getter will return the default value (`const <String>[]`).
  Future<void> removeEmptyStringList() {
    return _prefs.remove('emptyStringList');
  }

  /// Removes all preferences managed by this class from storage.
  ///
  /// After calling this, all getters return their default values.
  Future<void> clearAll() {
    return Future.wait([
      _prefs.remove('nullableInt'),
      _prefs.remove('nullableDouble'),
      _prefs.remove('nullableBool'),
      _prefs.remove('emptyStringList'),
    ]);
  }
}
