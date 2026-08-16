// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'main.dart';

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await SettingsPrefsImpl.init()` on startup,
/// then access values via the singleton `SettingsPrefsImpl.instance`.
///
/// **DI & Testing**: inject a backend directly: `SettingsPrefsImpl(backend)`.
class SettingsPrefsImpl {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  SettingsPrefsImpl(
    this._prefs, {
    void Function(String key, Object error)? onReadError,
  }) : _onReadError = onReadError;

  static SettingsPrefsImpl? _instance;

  static Future<SettingsPrefsImpl>? _initFuture;

  /// Optional callback invoked when a stored value cannot be cast to its
  /// expected type (e.g. after a field type change between app versions).
  ///
  /// Receives the preference key and the exception. Use this to forward
  /// errors to a crash reporter (Crashlytics, Sentry, etc.).
  final void Function(String key, Object error)? _onReadError;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static SettingsPrefsImpl get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'SettingsPrefsImpl has not been initialized. '
        'Call `await SettingsPrefsImpl.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  ///
  /// Note: [onReadError] is captured only during the initial call to [init].
  /// Subsequent calls will return the existing instance and ignore new callbacks.
  static Future<SettingsPrefsImpl> init({
    void Function(String key, Object error)? onReadError,
  }) {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit(onReadError: onReadError);
  }

  static Future<SettingsPrefsImpl> _doInit({
    void Function(String key, Object error)? onReadError,
  }) async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = SettingsPrefsImpl(prefs, onReadError: onReadError);
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

  /// Gets the value for `isLight` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  bool? get isLight {
    try {
      return _prefs.getBool('isLight');
    } catch (e) {
      _onReadError?.call('isLight', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `isLight`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setIsLight(bool? value) {
    if (value == null) {
      return _prefs.remove('isLight');
    }
    return _prefs.setBool('isLight', value);
  }

  /// Checks if a value has been explicitly set for `isLight`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsIsLight() {
    return _prefs.containsKey('isLight');
  }

  /// Removes the stored value for `isLight`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeIsLight() {
    return _prefs.remove('isLight');
  }

  /// Gets the value for `recentItemIds` from the cache.
  ///
  /// If the key does not exist, the default value `const <int>[]` is returned.
  List<int> get recentItemIds {
    try {
      final raw = _prefs.getStringList('recentItemIds');
      return raw == null
          ? const <int>[]
          : List.unmodifiable(raw.map(int.parse).toList());
    } catch (e) {
      _onReadError?.call('recentItemIds', e);
      return const <int>[];
    }
  }

  /// Asynchronously sets the value for `recentItemIds`.
  Future<void> setRecentItemIds(List<int> value) {
    return _prefs.setStringList(
      'recentItemIds',
      value.map((e) => e.toString()).toList(),
    );
  }

  /// Checks if a value has been explicitly set for `recentItemIds`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsRecentItemIds() {
    return _prefs.containsKey('recentItemIds');
  }

  /// Removes the stored value for `recentItemIds`.
  ///
  /// After calling this, the getter will return the default value (`const <int>[]`).
  Future<void> removeRecentItemIds() {
    return _prefs.remove('recentItemIds');
  }

  /// Removes all preferences managed by this class from storage.
  ///
  /// After calling this, all getters return their default values.
  ///
  /// **Note:** This operation is not atomic. Concurrent writes during this
  /// operation may result in keys remaining in storage.
  Future<void> clearAll() {
    return Future.wait([
      _prefs.remove('isLight'),
      _prefs.remove('recentItemIds'),
    ]);
  }
}
