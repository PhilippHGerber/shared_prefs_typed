// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'theme_example.dart';

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

  /// Gets the value for `themeMode` from the cache.
  ///
  /// If the key does not exist, the default value `ThemeMode.system` is returned.
  ThemeMode get themeMode {
    try {
      final raw = _prefs.getString('themeMode');
      if (raw == null) return ThemeMode.system;
      return ThemeMode.values.byName(raw);
    } catch (e, s) {
      developer.log(
        'Read error for key "themeMode"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('themeMode', e);
      return ThemeMode.system;
    }
  }

  /// Asynchronously sets the value for `themeMode`.
  Future<void> setThemeMode(ThemeMode value) {
    return _prefs.setString('themeMode', value.name);
  }

  /// Checks if a value has been explicitly set for `themeMode`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsThemeMode() {
    return _prefs.containsKey('themeMode');
  }

  /// Removes the stored value for `themeMode`.
  ///
  /// After calling this, the getter will return the default value (`ThemeMode.system`).
  Future<void> removeThemeMode() {
    return _prefs.remove('themeMode');
  }

  /// Removes all preferences managed by this class from storage.
  ///
  /// After calling this, all getters return their default values.
  ///
  /// **Note:** This operation is not atomic. Concurrent writes during this
  /// operation may result in keys remaining in storage.
  Future<void> clearAll() {
    return Future.wait([_prefs.remove('themeMode')]);
  }
}
