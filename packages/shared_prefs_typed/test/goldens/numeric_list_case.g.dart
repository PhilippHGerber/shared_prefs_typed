// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.
// ignore_for_file: unused_element, unused_field

import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'numeric_list_case.dart';

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await NumericListPrefs.init()` on startup,
/// then access values via the singleton `NumericListPrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `NumericListPrefs(backend)`.
class NumericListPrefs {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  NumericListPrefs(this._prefs);

  static NumericListPrefs? _instance;

  static Future<NumericListPrefs>? _initFuture;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static NumericListPrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'NumericListPrefs has not been initialized. '
        'Call `await NumericListPrefs.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<NumericListPrefs> init() {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit();
  }

  static Future<NumericListPrefs> _doInit() async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = NumericListPrefs(prefs);
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

  /// Gets the value for `intList` from the cache.
  ///
  /// If the key does not exist, the default value `const <int>[1, 2, 3]` is returned.
  List<int> get intList {
    final raw = _prefs.getStringList('intList');
    return raw == null
        ? const <int>[1, 2, 3]
        : UnmodifiableListView(raw.map(int.parse).toList());
  }

  /// Asynchronously sets the value for `intList`.
  Future<void> setIntList(List<int> value) {
    return _prefs.setStringList(
      'intList',
      value.map((e) => e.toString()).toList(),
    );
  }

  /// Checks if a value has been explicitly set for `intList`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsIntList() {
    return _prefs.containsKey('intList');
  }

  /// Removes the stored value for `intList`.
  ///
  /// After calling this, the getter will return the default value (`const <int>[1, 2, 3]`).
  Future<void> removeIntList() {
    return _prefs.remove('intList');
  }

  /// Gets the value for `doubleList` from the cache.
  ///
  /// If the key does not exist, the default value `const <double>[1.5, 2.5]` is returned.
  List<double> get doubleList {
    final raw = _prefs.getStringList('doubleList');
    return raw == null
        ? const <double>[1.5, 2.5]
        : UnmodifiableListView(raw.map(double.parse).toList());
  }

  /// Asynchronously sets the value for `doubleList`.
  Future<void> setDoubleList(List<double> value) {
    return _prefs.setStringList(
      'doubleList',
      value.map((e) => e.toString()).toList(),
    );
  }

  /// Checks if a value has been explicitly set for `doubleList`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsDoubleList() {
    return _prefs.containsKey('doubleList');
  }

  /// Removes the stored value for `doubleList`.
  ///
  /// After calling this, the getter will return the default value (`const <double>[1.5, 2.5]`).
  Future<void> removeDoubleList() {
    return _prefs.remove('doubleList');
  }

  /// Gets the value for `nullableIntList` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  List<int>? get nullableIntList {
    final raw = _prefs.getStringList('nullableIntList');
    return raw == null
        ? null
        : UnmodifiableListView(raw.map(int.parse).toList());
  }

  /// Asynchronously sets the value for `nullableIntList`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setNullableIntList(List<int>? value) {
    if (value == null) {
      return _prefs.remove('nullableIntList');
    }
    return _prefs.setStringList(
      'nullableIntList',
      value.map((e) => e.toString()).toList(),
    );
  }

  /// Checks if a value has been explicitly set for `nullableIntList`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsNullableIntList() {
    return _prefs.containsKey('nullableIntList');
  }

  /// Removes the stored value for `nullableIntList`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeNullableIntList() {
    return _prefs.remove('nullableIntList');
  }

  /// Gets the value for `nullableDoubleList` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  List<double>? get nullableDoubleList {
    final raw = _prefs.getStringList('nullableDoubleList');
    return raw == null
        ? null
        : UnmodifiableListView(raw.map(double.parse).toList());
  }

  /// Asynchronously sets the value for `nullableDoubleList`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setNullableDoubleList(List<double>? value) {
    if (value == null) {
      return _prefs.remove('nullableDoubleList');
    }
    return _prefs.setStringList(
      'nullableDoubleList',
      value.map((e) => e.toString()).toList(),
    );
  }

  /// Checks if a value has been explicitly set for `nullableDoubleList`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsNullableDoubleList() {
    return _prefs.containsKey('nullableDoubleList');
  }

  /// Removes the stored value for `nullableDoubleList`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeNullableDoubleList() {
    return _prefs.remove('nullableDoubleList');
  }

  /// Removes all preferences managed by this class from storage.
  ///
  /// After calling this, all getters return their default values.
  Future<void> clearAll() {
    return Future.wait([
      _prefs.remove('intList'),
      _prefs.remove('doubleList'),
      _prefs.remove('nullableIntList'),
      _prefs.remove('nullableDoubleList'),
    ]);
  }
}
