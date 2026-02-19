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

import 'bool_list_case.dart';

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await BoolListPrefs.init()` on startup,
/// then access values via the singleton `BoolListPrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `BoolListPrefs(backend)`.
class BoolListPrefs {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  BoolListPrefs(
    this._prefs, {
    void Function(String key, Object error)? onReadError,
  }) : _onReadError = onReadError;

  static BoolListPrefs? _instance;

  static Future<BoolListPrefs>? _initFuture;

  /// Optional callback invoked when a stored value cannot be cast to its
  /// expected type (e.g. after a field type change between app versions).
  ///
  /// Receives the preference key and the exception. Use this to forward
  /// errors to a crash reporter (Crashlytics, Sentry, etc.).
  final void Function(String key, Object error)? _onReadError;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static BoolListPrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'BoolListPrefs has not been initialized. '
        'Call `await BoolListPrefs.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<BoolListPrefs> init({
    void Function(String key, Object error)? onReadError,
  }) {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit(onReadError: onReadError);
  }

  static Future<BoolListPrefs> _doInit({
    void Function(String key, Object error)? onReadError,
  }) async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = BoolListPrefs(prefs, onReadError: onReadError);
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

  /// Gets the value for `flags` from the cache.
  ///
  /// If the key does not exist, the default value `const <bool>[true, false, true]` is returned.
  List<bool> get flags {
    final raw = _prefs.getStringList('flags');
    return raw == null
        ? const <bool>[true, false, true]
        : UnmodifiableListView(raw.map((e) => e == 'true').toList());
  }

  /// Asynchronously sets the value for `flags`.
  Future<void> setFlags(List<bool> value) {
    return _prefs.setStringList(
      'flags',
      value.map((e) => e.toString()).toList(),
    );
  }

  /// Checks if a value has been explicitly set for `flags`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsFlags() {
    return _prefs.containsKey('flags');
  }

  /// Removes the stored value for `flags`.
  ///
  /// After calling this, the getter will return the default value (`const <bool>[true, false, true]`).
  Future<void> removeFlags() {
    return _prefs.remove('flags');
  }

  /// Gets the value for `optionalFlags` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  List<bool>? get optionalFlags {
    final raw = _prefs.getStringList('optionalFlags');
    return raw == null
        ? null
        : UnmodifiableListView(raw.map((e) => e == 'true').toList());
  }

  /// Asynchronously sets the value for `optionalFlags`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setOptionalFlags(List<bool>? value) {
    if (value == null) {
      return _prefs.remove('optionalFlags');
    }
    return _prefs.setStringList(
      'optionalFlags',
      value.map((e) => e.toString()).toList(),
    );
  }

  /// Checks if a value has been explicitly set for `optionalFlags`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsOptionalFlags() {
    return _prefs.containsKey('optionalFlags');
  }

  /// Removes the stored value for `optionalFlags`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeOptionalFlags() {
    return _prefs.remove('optionalFlags');
  }

  /// Removes all preferences managed by this class from storage.
  ///
  /// After calling this, all getters return their default values.
  ///
  /// **Note:** This operation is not atomic. Concurrent writes during this
  /// operation may result in keys remaining in storage.
  Future<void> clearAll() {
    return Future.wait([
      _prefs.remove('flags'),
      _prefs.remove('optionalFlags'),
    ]);
  }
}
