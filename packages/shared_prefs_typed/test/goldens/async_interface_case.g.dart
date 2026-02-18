// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.
// ignore_for_file: unused_element, unused_field

import 'package:shared_preferences/shared_preferences.dart';

import 'async_interface_case.dart';

/// Abstract interface for [AsyncInterfacePrefs].
///
/// Implement or mock this for dependency injection and testing.
abstract class AsyncInterfacePrefsBase {
  Future<String> get message;
  Future<void> setMessage(String value);
  Future<bool> isSetMessage();
  Future<void> removeMessage();
  Future<int> get count;
  Future<void> setCount(int value);
  Future<bool> isSetCount();
  Future<void> removeCount();
}

/// Provides type-safe, asynchronous access to application preferences.
///
/// **Simple apps**: call `await AsyncInterfacePrefs.init()` on startup,
/// then access values via the singleton `AsyncInterfacePrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `AsyncInterfacePrefs(backend)`.
class AsyncInterfacePrefs implements AsyncInterfacePrefsBase {
  /// Creates an instance backed by the given [SharedPreferencesAsync].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  const AsyncInterfacePrefs(this._prefs);

  static AsyncInterfacePrefs? _instance;

  static Future<AsyncInterfacePrefs>? _initFuture;

  final SharedPreferencesAsync _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static AsyncInterfacePrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'AsyncInterfacePrefs has not been initialized. '
        'Call `await AsyncInterfacePrefs.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<AsyncInterfacePrefs> init() {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit();
  }

  static Future<AsyncInterfacePrefs> _doInit() {
    return Future.value(
      _instance = AsyncInterfacePrefs(SharedPreferencesAsync()),
    );
  }

  /// Resets the singleton instance to `null`. Useful for test teardown.
  static void resetInstance() {
    _instance = null;
    _initFuture = null;
  }

  /// Asynchronously gets the value for `message`.
  ///
  /// If the key does not exist, the default value `'hello'` is returned.
  Future<String> get message async {
    return (await _prefs.getString('message')) ?? 'hello';
  }

  /// Asynchronously sets the value for `message`.
  Future<void> setMessage(String value) {
    return _prefs.setString('message', value);
  }

  /// Checks if a value has been explicitly set for `message`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  Future<bool> isSetMessage() {
    return _prefs.containsKey('message');
  }

  /// Removes the stored value for `message`.
  ///
  /// After calling this, the getter will return the default value (`'hello'`).
  Future<void> removeMessage() {
    return _prefs.remove('message');
  }

  /// Asynchronously gets the value for `count`.
  ///
  /// If the key does not exist, the default value `0` is returned.
  Future<int> get count async {
    return (await _prefs.getInt('count')) ?? 0;
  }

  /// Asynchronously sets the value for `count`.
  Future<void> setCount(int value) {
    return _prefs.setInt('count', value);
  }

  /// Checks if a value has been explicitly set for `count`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  Future<bool> isSetCount() {
    return _prefs.containsKey('count');
  }

  /// Removes the stored value for `count`.
  ///
  /// After calling this, the getter will return the default value (`0`).
  Future<void> removeCount() {
    return _prefs.remove('count');
  }
}
