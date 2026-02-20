// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'async_preferences.dart';

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.

/// Provides type-safe, asynchronous access to application preferences.
///
/// **Simple apps**: call `await AsyncPreferencesImpl.init()` on startup,
/// then access values via the singleton `AsyncPreferencesImpl.instance`.
///
/// **DI & Testing**: inject a backend directly: `AsyncPreferencesImpl(backend)`.
class AsyncPreferencesImpl {
  /// Creates an instance backed by the given [SharedPreferencesAsync].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  AsyncPreferencesImpl(
    this._prefs, {
    void Function(String key, Object error)? onReadError,
  }) : _onReadError = onReadError;

  static AsyncPreferencesImpl? _instance;

  static Future<AsyncPreferencesImpl>? _initFuture;

  /// Optional callback invoked when a stored value cannot be cast to its
  /// expected type (e.g. after a field type change between app versions).
  ///
  /// Receives the preference key and the exception. Use this to forward
  /// errors to a crash reporter (Crashlytics, Sentry, etc.).
  final void Function(String key, Object error)? _onReadError;

  final SharedPreferencesAsync _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static AsyncPreferencesImpl get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'AsyncPreferencesImpl has not been initialized. '
        'Call `await AsyncPreferencesImpl.init()` before accessing `instance`.',
      );
    }
    return i;
  }

  /// Initializes and returns the singleton [instance].
  ///
  /// Safe to call multiple times — concurrent calls share the same future
  /// and do not trigger additional I/O.
  static Future<AsyncPreferencesImpl> init({
    void Function(String key, Object error)? onReadError,
  }) {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit(onReadError: onReadError);
  }

  static Future<AsyncPreferencesImpl> _doInit({
    void Function(String key, Object error)? onReadError,
  }) {
    return Future.value(
      _instance = AsyncPreferencesImpl(
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

  /// Asynchronously gets the value for `pingCount`.
  ///
  /// If the key does not exist, the default value `0` is returned.
  Future<int> get pingCount async {
    try {
      return (await _prefs.getInt('pingCount')) ?? 0;
    } catch (e) {
      _onReadError?.call('pingCount', e);
      return 0;
    }
  }

  /// Asynchronously sets the value for `pingCount`.
  Future<void> setPingCount(int value) {
    return _prefs.setInt('pingCount', value);
  }

  /// Checks if a value has been explicitly set for `pingCount`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  Future<bool> containsPingCount() {
    return _prefs.containsKey('pingCount');
  }

  /// Removes the stored value for `pingCount`.
  ///
  /// After calling this, the getter will return the default value (`0`).
  Future<void> removePingCount() {
    return _prefs.remove('pingCount');
  }

  /// Asynchronously gets the value for `serverId`.
  ///
  /// If the key does not exist, the default value `null` is returned.
  Future<String?> get serverId async {
    try {
      return (await _prefs.getString('serverId'));
    } catch (e) {
      _onReadError?.call('serverId', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `serverId`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setServerId(String? value) {
    if (value == null) {
      return _prefs.remove('serverId');
    }
    return _prefs.setString('serverId', value);
  }

  /// Checks if a value has been explicitly set for `serverId`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  Future<bool> containsServerId() {
    return _prefs.containsKey('serverId');
  }

  /// Removes the stored value for `serverId`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeServerId() {
    return _prefs.remove('serverId');
  }

  /// Asynchronously gets the value for `isCacheEnabled`.
  ///
  /// If the key does not exist, the default value `true` is returned.
  Future<bool> get isCacheEnabled async {
    try {
      return (await _prefs.getBool('isCacheEnabled')) ?? true;
    } catch (e) {
      _onReadError?.call('isCacheEnabled', e);
      return true;
    }
  }

  /// Asynchronously sets the value for `isCacheEnabled`.
  Future<void> setIsCacheEnabled(bool value) {
    return _prefs.setBool('isCacheEnabled', value);
  }

  /// Checks if a value has been explicitly set for `isCacheEnabled`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  Future<bool> containsIsCacheEnabled() {
    return _prefs.containsKey('isCacheEnabled');
  }

  /// Removes the stored value for `isCacheEnabled`.
  ///
  /// After calling this, the getter will return the default value (`true`).
  Future<void> removeIsCacheEnabled() {
    return _prefs.remove('isCacheEnabled');
  }

  /// Removes all preferences managed by this class from storage.
  ///
  /// After calling this, all getters return their default values.
  ///
  /// **Note:** This operation is not atomic. Concurrent writes during this
  /// operation may result in keys remaining in storage.
  Future<void> clearAll() {
    return Future.wait([
      _prefs.remove('pingCount'),
      _prefs.remove('serverId'),
      _prefs.remove('isCacheEnabled'),
    ]);
  }
}
