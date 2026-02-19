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

import 'enum_case.dart';

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await EnumPrefs.init()` on startup,
/// then access values via the singleton `EnumPrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `EnumPrefs(backend)`.
class EnumPrefs {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  EnumPrefs(this._prefs, {void Function(String key, Object error)? onReadError})
    : _onReadError = onReadError;

  static EnumPrefs? _instance;

  static Future<EnumPrefs>? _initFuture;

  /// Optional callback invoked when a stored value cannot be cast to its
  /// expected type (e.g. after a field type change between app versions).
  ///
  /// Receives the preference key and the exception. Use this to forward
  /// errors to a crash reporter (Crashlytics, Sentry, etc.).
  final void Function(String key, Object error)? _onReadError;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static EnumPrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'EnumPrefs has not been initialized. '
        'Call `await EnumPrefs.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<EnumPrefs> init({
    void Function(String key, Object error)? onReadError,
  }) {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit(onReadError: onReadError);
  }

  static Future<EnumPrefs> _doInit({
    void Function(String key, Object error)? onReadError,
  }) async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = EnumPrefs(prefs, onReadError: onReadError);
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

  /// Gets the value for `theme` from the cache.
  ///
  /// If the key does not exist, the default value `ThemeMode.dark` is returned.
  ThemeMode get theme {
    try {
      final raw = _prefs.getString('theme');
      if (raw == null) return ThemeMode.dark;
      return ThemeMode.values.byName(raw);
    } catch (e) {
      log(
        '[shared_prefs_typed] Failed to read "theme": ${e.runtimeType}. Default will be used.',
        name: 'shared_prefs_typed',
      );
      _onReadError?.call('theme', e);
      return ThemeMode.dark;
    }
  }

  /// Asynchronously sets the value for `theme`.
  Future<void> setTheme(ThemeMode value) {
    return _prefs.setString('theme', value.name);
  }

  /// Checks if a value has been explicitly set for `theme`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsTheme() {
    return _prefs.containsKey('theme');
  }

  /// Removes the stored value for `theme`.
  ///
  /// After calling this, the getter will return the default value (`ThemeMode.dark`).
  Future<void> removeTheme() {
    return _prefs.remove('theme');
  }

  /// Gets the value for `optionalTheme` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  ThemeMode? get optionalTheme {
    try {
      final raw = _prefs.getString('optionalTheme');
      if (raw == null) return null;
      return ThemeMode.values.byName(raw);
    } catch (e) {
      log(
        '[shared_prefs_typed] Failed to read "optionalTheme": ${e.runtimeType}. Default will be used.',
        name: 'shared_prefs_typed',
      );
      _onReadError?.call('optionalTheme', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `optionalTheme`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setOptionalTheme(ThemeMode? value) {
    if (value == null) {
      return _prefs.remove('optionalTheme');
    }
    return _prefs.setString('optionalTheme', value.name);
  }

  /// Checks if a value has been explicitly set for `optionalTheme`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsOptionalTheme() {
    return _prefs.containsKey('optionalTheme');
  }

  /// Removes the stored value for `optionalTheme`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeOptionalTheme() {
    return _prefs.remove('optionalTheme');
  }

  /// Gets the value for `fontSize` from the cache.
  ///
  /// If the key does not exist, the default value `FontSize.medium` is returned.
  FontSize get fontSize {
    try {
      final raw = _prefs.getString('fontSize');
      if (raw == null) return FontSize.medium;
      return FontSize.values.byName(raw);
    } catch (e) {
      log(
        '[shared_prefs_typed] Failed to read "fontSize": ${e.runtimeType}. Default will be used.',
        name: 'shared_prefs_typed',
      );
      _onReadError?.call('fontSize', e);
      return FontSize.medium;
    }
  }

  /// Asynchronously sets the value for `fontSize`.
  Future<void> setFontSize(FontSize value) {
    return _prefs.setString('fontSize', value.name);
  }

  /// Checks if a value has been explicitly set for `fontSize`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsFontSize() {
    return _prefs.containsKey('fontSize');
  }

  /// Removes the stored value for `fontSize`.
  ///
  /// After calling this, the getter will return the default value (`FontSize.medium`).
  Future<void> removeFontSize() {
    return _prefs.remove('fontSize');
  }

  /// Removes all preferences managed by this class from storage.
  ///
  /// After calling this, all getters return their default values.
  Future<void> clearAll() {
    return Future.wait([
      _prefs.remove('theme'),
      _prefs.remove('optionalTheme'),
      _prefs.remove('fontSize'),
    ]);
  }
}
