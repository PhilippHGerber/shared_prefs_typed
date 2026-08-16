// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'date_time_millis_case.dart';

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await DateTimeMillisPrefs.init()` on startup,
/// then access values via the singleton `DateTimeMillisPrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `DateTimeMillisPrefs(backend)`.
class DateTimeMillisPrefs {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  DateTimeMillisPrefs(
    this._prefs, {
    void Function(String key, Object error)? onReadError,
  }) : _onReadError = onReadError;

  static DateTimeMillisPrefs? _instance;

  static Future<DateTimeMillisPrefs>? _initFuture;

  /// Optional callback invoked when a stored value cannot be cast to its
  /// expected type (e.g. after a field type change between app versions).
  ///
  /// Receives the preference key and the exception. Use this to forward
  /// errors to a crash reporter (Crashlytics, Sentry, etc.).
  final void Function(String key, Object error)? _onReadError;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static DateTimeMillisPrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'DateTimeMillisPrefs has not been initialized. '
        'Call `await DateTimeMillisPrefs.init()` before accessing `instance`.',
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
  static Future<DateTimeMillisPrefs> init({
    void Function(String key, Object error)? onReadError,
  }) {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit(onReadError: onReadError);
  }

  static Future<DateTimeMillisPrefs> _doInit({
    void Function(String key, Object error)? onReadError,
  }) async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = DateTimeMillisPrefs(prefs, onReadError: onReadError);
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

  /// Gets the value for `lastLogin` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  DateTime? get lastLogin {
    try {
      final raw = _prefs.getInt('lastLogin');
      if (raw == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(raw);
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
    return _prefs.setInt('lastLogin', value.millisecondsSinceEpoch);
  }

  /// Checks if a value has been explicitly set for `lastLogin`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsLastLogin() {
    return _prefs.containsKey('lastLogin');
  }

  /// Removes the stored value for `lastLogin`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeLastLogin() {
    return _prefs.remove('lastLogin');
  }

  /// Gets the value for `createdAt` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  DateTime? get createdAt {
    try {
      final raw = _prefs.getInt('createdAt');
      if (raw == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(raw);
    } catch (e, s) {
      developer.log(
        'Read error for key "createdAt"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('createdAt', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `createdAt`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setCreatedAt(DateTime? value) {
    if (value == null) {
      return _prefs.remove('createdAt');
    }
    return _prefs.setInt('createdAt', value.millisecondsSinceEpoch);
  }

  /// Checks if a value has been explicitly set for `createdAt`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsCreatedAt() {
    return _prefs.containsKey('createdAt');
  }

  /// Removes the stored value for `createdAt`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeCreatedAt() {
    return _prefs.remove('createdAt');
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
      _prefs.remove('createdAt'),
    ]);
  }
}
