// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'app_preferences.dart';

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.

/// Abstract interface for [AppPreferencesImpl].
///
/// Implement or mock this for dependency injection and testing.
abstract class AppPreferencesBase {
  int get counter;
  Future<void> setCounter(int value);
  bool containsCounter();
  Future<void> removeCounter();
  ThemeMode get themeMode;
  Future<void> setThemeMode(ThemeMode value);
  bool containsThemeMode();
  Future<void> removeThemeMode();
  String? get username;
  Future<void> setUsername(String? value);
  bool containsUsername();
  Future<void> removeUsername();
  Future<void> clearAll();
}

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await AppPreferencesImpl.init()` on startup,
/// then access values via the singleton `AppPreferencesImpl.instance`.
///
/// **DI & Testing**: inject a backend directly: `AppPreferencesImpl(backend)`.
class AppPreferencesImpl implements AppPreferencesBase {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  AppPreferencesImpl(
    this._prefs, {
    void Function(String key, Object error)? onReadError,
  }) : _onReadError = onReadError;

  static AppPreferencesImpl? _instance;

  static Future<AppPreferencesImpl>? _initFuture;

  /// Optional callback invoked when a stored value cannot be cast to its
  /// expected type (e.g. after a field type change between app versions).
  ///
  /// Receives the preference key and the exception. Use this to forward
  /// errors to a crash reporter (Crashlytics, Sentry, etc.).
  final void Function(String key, Object error)? _onReadError;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static AppPreferencesImpl get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'AppPreferencesImpl has not been initialized. '
        'Call `await AppPreferencesImpl.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<AppPreferencesImpl> init({
    void Function(String key, Object error)? onReadError,
  }) {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit(onReadError: onReadError);
  }

  static Future<AppPreferencesImpl> _doInit({
    void Function(String key, Object error)? onReadError,
  }) async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = AppPreferencesImpl(prefs, onReadError: onReadError);
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

  /// Gets the value for `counter` from the cache.
  ///
  /// If the key does not exist, the default value `0` is returned.
  int get counter {
    try {
      return _prefs.getInt('counter') ?? 0;
    } catch (e) {
      _onReadError?.call('counter', e);
      return 0;
    }
  }

  /// Asynchronously sets the value for `counter`.
  Future<void> setCounter(int value) {
    return _prefs.setInt('counter', value);
  }

  /// Checks if a value has been explicitly set for `counter`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsCounter() {
    return _prefs.containsKey('counter');
  }

  /// Removes the stored value for `counter`.
  ///
  /// After calling this, the getter will return the default value (`0`).
  Future<void> removeCounter() {
    return _prefs.remove('counter');
  }

  /// Gets the value for `themeMode` from the cache.
  ///
  /// If the key does not exist, the default value `ThemeMode.system` is returned.
  ThemeMode get themeMode {
    try {
      final raw = _prefs.getString('themeMode');
      if (raw == null) return ThemeMode.system;
      return ThemeMode.values.byName(raw);
    } catch (e) {
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

  /// Gets the value for `username` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  String? get username {
    try {
      return _prefs.getString('username');
    } catch (e) {
      _onReadError?.call('username', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `username`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setUsername(String? value) {
    if (value == null) {
      return _prefs.remove('username');
    }
    return _prefs.setString('username', value);
  }

  /// Checks if a value has been explicitly set for `username`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsUsername() {
    return _prefs.containsKey('username');
  }

  /// Removes the stored value for `username`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeUsername() {
    return _prefs.remove('username');
  }

  /// Removes all preferences managed by this class from storage.
  ///
  /// After calling this, all getters return their default values.
  ///
  /// **Note:** This operation is not atomic. Concurrent writes during this
  /// operation may result in keys remaining in storage.
  Future<void> clearAll() {
    return Future.wait([
      _prefs.remove('counter'),
      _prefs.remove('themeMode'),
      _prefs.remove('username'),
    ]);
  }
}
