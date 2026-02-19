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

import 'async_interface_case.dart';

/// Abstract interface for [AsyncInterfacePrefs].
///
/// Implement or mock this for dependency injection and testing.
abstract class AsyncInterfacePrefsBase {
  Future<String> get message;
  Future<void> setMessage(String value);
  Future<bool> containsMessage();
  Future<void> removeMessage();
  Future<int> get count;
  Future<void> setCount(int value);
  Future<bool> containsCount();
  Future<void> removeCount();
  Future<void> clearAll();
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
  AsyncInterfacePrefs(
    this._prefs, {
    void Function(String key, Object error)? onReadError,
  }) : _onReadError = onReadError;

  static AsyncInterfacePrefs? _instance;

  static Future<AsyncInterfacePrefs>? _initFuture;

  /// Optional callback invoked when a stored value cannot be cast to its
  /// expected type (e.g. after a field type change between app versions).
  ///
  /// Receives the preference key and the exception. Use this to forward
  /// errors to a crash reporter (Crashlytics, Sentry, etc.).
  final void Function(String key, Object error)? _onReadError;

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
  static Future<AsyncInterfacePrefs> init({
    void Function(String key, Object error)? onReadError,
  }) {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit(onReadError: onReadError);
  }

  static Future<AsyncInterfacePrefs> _doInit({
    void Function(String key, Object error)? onReadError,
  }) {
    return Future.value(
      _instance = AsyncInterfacePrefs(
        SharedPreferencesAsync(),
        onReadError: onReadError,
      ),
    );
  }

  /// Resets the singleton instance to `null`. Useful for test teardown.
  @visibleForTesting
  static void resetInstance() {
    _instance = null;
    _initFuture = null;
  }

  /// Asynchronously gets the value for `message`.
  ///
  /// If the key does not exist, the default value `'hello'` is returned.
  Future<String> get message async {
    try {
      return (await _prefs.getString('message')) ?? 'hello';
    } catch (e) {
      log(
        '[shared_prefs_typed] Failed to read "message": ${e.runtimeType}. Default will be used.',
        name: 'shared_prefs_typed',
      );
      _onReadError?.call('message', e);
      return 'hello';
    }
  }

  /// Asynchronously sets the value for `message`.
  Future<void> setMessage(String value) {
    return _prefs.setString('message', value);
  }

  /// Checks if a value has been explicitly set for `message`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  Future<bool> containsMessage() {
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
    try {
      return (await _prefs.getInt('count')) ?? 0;
    } catch (e) {
      log(
        '[shared_prefs_typed] Failed to read "count": ${e.runtimeType}. Default will be used.',
        name: 'shared_prefs_typed',
      );
      _onReadError?.call('count', e);
      return 0;
    }
  }

  /// Asynchronously sets the value for `count`.
  Future<void> setCount(int value) {
    return _prefs.setInt('count', value);
  }

  /// Checks if a value has been explicitly set for `count`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  Future<bool> containsCount() {
    return _prefs.containsKey('count');
  }

  /// Removes the stored value for `count`.
  ///
  /// After calling this, the getter will return the default value (`0`).
  Future<void> removeCount() {
    return _prefs.remove('count');
  }

  /// Removes all preferences managed by this class from storage.
  ///
  /// After calling this, all getters return their default values.
  Future<void> clearAll() {
    return Future.wait([_prefs.remove('message'), _prefs.remove('count')]);
  }
}
