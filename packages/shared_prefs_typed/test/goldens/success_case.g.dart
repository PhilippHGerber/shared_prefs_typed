// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.
// ignore_for_file: unused_element, unused_field

import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';

import 'success_case.dart';

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await TestPrefs.init()` on startup,
/// then access values via the singleton `TestPrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `TestPrefs(backend)`.
class TestPrefs {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  const TestPrefs(this._prefs);

  static TestPrefs? _instance;

  static Future<TestPrefs>? _initFuture;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static TestPrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'TestPrefs has not been initialized. '
        'Call `await TestPrefs.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<TestPrefs> init() {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit();
  }

  static Future<TestPrefs> _doInit() async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = TestPrefs(prefs);
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

  /// Gets the value for `testInt` from the cache.
  ///
  /// If the key does not exist, the default value `10` is returned.
  int get testInt {
    try {
      return _prefs.getInt('testInt') ?? 10;
    } catch (_) {
      return 10;
    }
  }

  /// Asynchronously sets the value for `testInt`.
  Future<void> setTestInt(int value) {
    return _prefs.setInt('testInt', value);
  }

  /// Checks if a value has been explicitly set for `testInt`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetTestInt() {
    return _prefs.containsKey('testInt');
  }

  /// Removes the stored value for `testInt`.
  ///
  /// After calling this, the getter will return the default value (`10`).
  Future<void> removeTestInt() {
    return _prefs.remove('testInt');
  }

  /// Gets the value for `testDouble` from the cache.
  ///
  /// If the key does not exist, the default value `3.14` is returned.
  double get testDouble {
    try {
      return _prefs.getDouble('testDouble') ?? 3.14;
    } catch (_) {
      return 3.14;
    }
  }

  /// Asynchronously sets the value for `testDouble`.
  Future<void> setTestDouble(double value) {
    return _prefs.setDouble('testDouble', value);
  }

  /// Checks if a value has been explicitly set for `testDouble`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetTestDouble() {
    return _prefs.containsKey('testDouble');
  }

  /// Removes the stored value for `testDouble`.
  ///
  /// After calling this, the getter will return the default value (`3.14`).
  Future<void> removeTestDouble() {
    return _prefs.remove('testDouble');
  }

  /// Gets the value for `testBool` from the cache.
  ///
  /// If the key does not exist, the default value `true` is returned.
  bool get testBool {
    try {
      return _prefs.getBool('testBool') ?? true;
    } catch (_) {
      return true;
    }
  }

  /// Asynchronously sets the value for `testBool`.
  Future<void> setTestBool(bool value) {
    return _prefs.setBool('testBool', value);
  }

  /// Checks if a value has been explicitly set for `testBool`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetTestBool() {
    return _prefs.containsKey('testBool');
  }

  /// Removes the stored value for `testBool`.
  ///
  /// After calling this, the getter will return the default value (`true`).
  Future<void> removeTestBool() {
    return _prefs.remove('testBool');
  }

  /// Gets the value for `testString` from the cache.
  ///
  /// If the key does not exist, the default value `'Hello'` is returned.
  String get testString {
    try {
      return _prefs.getString('testString') ?? 'Hello';
    } catch (_) {
      return 'Hello';
    }
  }

  /// Asynchronously sets the value for `testString`.
  Future<void> setTestString(String value) {
    return _prefs.setString('testString', value);
  }

  /// Checks if a value has been explicitly set for `testString`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetTestString() {
    return _prefs.containsKey('testString');
  }

  /// Removes the stored value for `testString`.
  ///
  /// After calling this, the getter will return the default value (`'Hello'`).
  Future<void> removeTestString() {
    return _prefs.remove('testString');
  }

  /// Gets the value for `testStringList` from the cache.
  ///
  /// If the key does not exist, the default value `const <String>['a', 'b']` is returned.
  List<String> get testStringList {
    final raw = _prefs.getStringList('testStringList');
    return raw == null ? const <String>['a', 'b'] : UnmodifiableListView(raw);
  }

  /// Asynchronously sets the value for `testStringList`.
  Future<void> setTestStringList(List<String> value) {
    return _prefs.setStringList('testStringList', value);
  }

  /// Checks if a value has been explicitly set for `testStringList`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetTestStringList() {
    return _prefs.containsKey('testStringList');
  }

  /// Removes the stored value for `testStringList`.
  ///
  /// After calling this, the getter will return the default value (`const <String>['a', 'b']`).
  Future<void> removeTestStringList() {
    return _prefs.remove('testStringList');
  }

  /// Gets the value for `testNullableString` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  String? get testNullableString {
    try {
      return _prefs.getString('testNullableString');
    } catch (_) {
      return null;
    }
  }

  /// Asynchronously sets the value for `testNullableString`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setTestNullableString(String? value) {
    if (value == null) {
      return _prefs.remove('testNullableString');
    }
    return _prefs.setString('testNullableString', value);
  }

  /// Checks if a value has been explicitly set for `testNullableString`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetTestNullableString() {
    return _prefs.containsKey('testNullableString');
  }

  /// Removes the stored value for `testNullableString`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeTestNullableString() {
    return _prefs.remove('testNullableString');
  }
}
