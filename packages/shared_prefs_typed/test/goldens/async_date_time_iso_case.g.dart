// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'async_date_time_iso_case.dart';

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.

/// Provides type-safe, asynchronous access to application preferences.
///
/// **Simple apps**: call `await AsyncDateTimeIsoPrefs.init()` on startup,
/// then access values via the singleton `AsyncDateTimeIsoPrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `AsyncDateTimeIsoPrefs(backend)`.
class AsyncDateTimeIsoPrefs {
  /// Creates an instance backed by the given [SharedPreferencesAsync].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  AsyncDateTimeIsoPrefs(
    this._prefs, {
    void Function(String key, Object error)? onReadError,
  }) : _onReadError = onReadError;

  static AsyncDateTimeIsoPrefs? _instance;

  static Future<AsyncDateTimeIsoPrefs>? _initFuture;

  /// Optional callback invoked when a stored value cannot be cast to its
  /// expected type (e.g. after a field type change between app versions).
  ///
  /// Receives the preference key and the exception. Use this to forward
  /// errors to a crash reporter (Crashlytics, Sentry, etc.).
  final void Function(String key, Object error)? _onReadError;

  final SharedPreferencesAsync _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static AsyncDateTimeIsoPrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'AsyncDateTimeIsoPrefs has not been initialized. '
        'Call `await AsyncDateTimeIsoPrefs.init()` before accessing `instance`.',
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
  static Future<AsyncDateTimeIsoPrefs> init({
    void Function(String key, Object error)? onReadError,
  }) {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit(onReadError: onReadError);
  }

  static Future<AsyncDateTimeIsoPrefs> _doInit({
    void Function(String key, Object error)? onReadError,
  }) async {
    try {
      return _instance = AsyncDateTimeIsoPrefs(
        SharedPreferencesAsync(),
        onReadError: onReadError,
      );
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

  /// Asynchronously gets the value for `lastLogin`.
  ///
  /// If the key does not exist, the default value `null` is returned.
  Future<DateTime?> get lastLogin async {
    try {
      final raw = (await _prefs.getString('lastLogin'));
      if (raw == null) return null;
      return DateTime.parse(raw);
    } catch (e, s) {
      developer.log(
        'Read error for key "lastLogin"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('lastLogin', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `lastLogin`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setLastLogin(DateTime? value) {
    if (value == null) {
      return _prefs.remove('lastLogin');
    }
    return _prefs.setString('lastLogin', value.toIso8601String());
  }

  /// Checks if a value has been explicitly set for `lastLogin`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  Future<bool> containsLastLogin() {
    return _prefs.containsKey('lastLogin');
  }

  /// Removes the stored value for `lastLogin`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeLastLogin() {
    return _prefs.remove('lastLogin');
  }

  /// Asynchronously gets the value for `updatedAt`.
  ///
  /// If the key does not exist, the default value `null` is returned.
  Future<DateTime?> get updatedAt async {
    try {
      final raw = (await _prefs.getString('updatedAt'));
      if (raw == null) return null;
      return DateTime.parse(raw);
    } catch (e, s) {
      developer.log(
        'Read error for key "updatedAt"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('updatedAt', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `updatedAt`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setUpdatedAt(DateTime? value) {
    if (value == null) {
      return _prefs.remove('updatedAt');
    }
    return _prefs.setString('updatedAt', value.toIso8601String());
  }

  /// Checks if a value has been explicitly set for `updatedAt`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  Future<bool> containsUpdatedAt() {
    return _prefs.containsKey('updatedAt');
  }

  /// Removes the stored value for `updatedAt`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeUpdatedAt() {
    return _prefs.remove('updatedAt');
  }

  /// Removes all preferences managed by this class from storage.
  ///
  /// After calling this, all getters return their default values.
  ///
  /// **Note:** This operation is not atomic. Concurrent writes during this
  /// operation may result in keys remaining in storage.
  Future<void> clearAll() {
    return Future.wait([
      _prefs.remove('lastLogin'),
      _prefs.remove('updatedAt'),
    ]);
  }
}
