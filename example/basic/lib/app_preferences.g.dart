// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'app_preferences.dart';

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await AppPreferencesImpl.init()` on startup,
/// then access values via the singleton `AppPreferencesImpl.instance`.
///
/// **DI & Testing**: inject a backend directly: `AppPreferencesImpl(backend)`.
class AppPreferencesImpl {
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
  ///
  /// Note: [onReadError] is captured only during the initial call to [init].
  /// Subsequent calls will return the existing instance and ignore new callbacks.
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
    } catch (e, s) {
      developer.log(
        'Read error for key "counter"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
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

  /// Gets the value for `displayGreeting` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  String? get displayGreeting {
    try {
      return _prefs.getString('displayGreeting');
    } catch (e, s) {
      developer.log(
        'Read error for key "displayGreeting"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('displayGreeting', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `displayGreeting`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setDisplayGreeting(String? value) {
    if (value == null) {
      return _prefs.remove('displayGreeting');
    }
    return _prefs.setString('displayGreeting', value);
  }

  /// Checks if a value has been explicitly set for `displayGreeting`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsDisplayGreeting() {
    return _prefs.containsKey('displayGreeting');
  }

  /// Removes the stored value for `displayGreeting`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeDisplayGreeting() {
    return _prefs.remove('displayGreeting');
  }

  /// Gets the value for `pi` from the cache.
  ///
  /// If the key does not exist, the default value `3.14` is returned.
  double get pi {
    try {
      return _prefs.getDouble('pi') ?? 3.14;
    } catch (e, s) {
      developer.log(
        'Read error for key "pi"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('pi', e);
      return 3.14;
    }
  }

  /// Asynchronously sets the value for `pi`.
  Future<void> setPi(double value) {
    return _prefs.setDouble('pi', value);
  }

  /// Checks if a value has been explicitly set for `pi`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsPi() {
    return _prefs.containsKey('pi');
  }

  /// Removes the stored value for `pi`.
  ///
  /// After calling this, the getter will return the default value (`3.14`).
  Future<void> removePi() {
    return _prefs.remove('pi');
  }

  /// Gets the value for `isWelcomeScreenDone` from the cache.
  ///
  /// If the key does not exist, the default value `false` is returned.
  bool get isWelcomeScreenDone {
    try {
      return _prefs.getBool('isWelcomeScreenDone') ?? false;
    } catch (e, s) {
      developer.log(
        'Read error for key "isWelcomeScreenDone"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('isWelcomeScreenDone', e);
      return false;
    }
  }

  /// Asynchronously sets the value for `isWelcomeScreenDone`.
  Future<void> setIsWelcomeScreenDone(bool value) {
    return _prefs.setBool('isWelcomeScreenDone', value);
  }

  /// Checks if a value has been explicitly set for `isWelcomeScreenDone`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsIsWelcomeScreenDone() {
    return _prefs.containsKey('isWelcomeScreenDone');
  }

  /// Removes the stored value for `isWelcomeScreenDone`.
  ///
  /// After calling this, the getter will return the default value (`false`).
  Future<void> removeIsWelcomeScreenDone() {
    return _prefs.remove('isWelcomeScreenDone');
  }

  /// Gets the value for `greeting` from the cache.
  ///
  /// If the key does not exist, the default value `'Hello'` is returned.
  String get greeting {
    try {
      return _prefs.getString('greeting') ?? 'Hello';
    } catch (e, s) {
      developer.log(
        'Read error for key "greeting"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('greeting', e);
      return 'Hello';
    }
  }

  /// Asynchronously sets the value for `greeting`.
  Future<void> setGreeting(String value) {
    return _prefs.setString('greeting', value);
  }

  /// Checks if a value has been explicitly set for `greeting`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsGreeting() {
    return _prefs.containsKey('greeting');
  }

  /// Removes the stored value for `greeting`.
  ///
  /// After calling this, the getter will return the default value (`'Hello'`).
  Future<void> removeGreeting() {
    return _prefs.remove('greeting');
  }

  /// Gets the value for `tagList` from the cache.
  ///
  /// If the key does not exist, the default value `const <String>['default']` is returned.
  List<String> get tagList {
    try {
      final raw = _prefs.getStringList('tagList');
      return raw == null ? const <String>['default'] : List.unmodifiable(raw);
    } catch (e, s) {
      developer.log(
        'Read error for key "tagList"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('tagList', e);
      return const <String>['default'];
    }
  }

  /// Asynchronously sets the value for `tagList`.
  Future<void> setTagList(List<String> value) {
    return _prefs.setStringList('tagList', value);
  }

  /// Checks if a value has been explicitly set for `tagList`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsTagList() {
    return _prefs.containsKey('tagList');
  }

  /// Removes the stored value for `tagList`.
  ///
  /// After calling this, the getter will return the default value (`const <String>['default']`).
  Future<void> removeTagList() {
    return _prefs.remove('tagList');
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
    } catch (e, s) {
      developer.log(
        'Read error for key "recentItemIds"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
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

  /// Gets the value for `priceHistory` from the cache.
  ///
  /// If the key does not exist, the default value `const <double>[9.99, 14.99, 19.99]` is returned.
  List<double> get priceHistory {
    try {
      final raw = _prefs.getStringList('priceHistory');
      return raw == null
          ? const <double>[9.99, 14.99, 19.99]
          : List.unmodifiable(raw.map(double.parse).toList());
    } catch (e, s) {
      developer.log(
        'Read error for key "priceHistory"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('priceHistory', e);
      return const <double>[9.99, 14.99, 19.99];
    }
  }

  /// Asynchronously sets the value for `priceHistory`.
  Future<void> setPriceHistory(List<double> value) {
    return _prefs.setStringList(
      'priceHistory',
      value.map((e) => e.toString()).toList(),
    );
  }

  /// Checks if a value has been explicitly set for `priceHistory`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsPriceHistory() {
    return _prefs.containsKey('priceHistory');
  }

  /// Removes the stored value for `priceHistory`.
  ///
  /// After calling this, the getter will return the default value (`const <double>[9.99, 14.99, 19.99]`).
  Future<void> removePriceHistory() {
    return _prefs.remove('priceHistory');
  }

  /// Gets the value for `sessionId` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  String? get sessionId {
    try {
      return _prefs.getString('sessionId');
    } catch (e, s) {
      developer.log(
        'Read error for key "sessionId"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('sessionId', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `sessionId`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setSessionId(String? value) {
    if (value == null) {
      return _prefs.remove('sessionId');
    }
    return _prefs.setString('sessionId', value);
  }

  /// Checks if a value has been explicitly set for `sessionId`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsSessionId() {
    return _prefs.containsKey('sessionId');
  }

  /// Removes the stored value for `sessionId`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeSessionId() {
    return _prefs.remove('sessionId');
  }

  /// Gets the value for `lastLoginTimestamp` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  int? get lastLoginTimestamp {
    try {
      return _prefs.getInt('lastLoginTimestamp');
    } catch (e, s) {
      developer.log(
        'Read error for key "lastLoginTimestamp"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('lastLoginTimestamp', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `lastLoginTimestamp`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setLastLoginTimestamp(int? value) {
    if (value == null) {
      return _prefs.remove('lastLoginTimestamp');
    }
    return _prefs.setInt('lastLoginTimestamp', value);
  }

  /// Checks if a value has been explicitly set for `lastLoginTimestamp`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsLastLoginTimestamp() {
    return _prefs.containsKey('lastLoginTimestamp');
  }

  /// Removes the stored value for `lastLoginTimestamp`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeLastLoginTimestamp() {
    return _prefs.remove('lastLoginTimestamp');
  }

  /// Gets the value for `nullableCounterWithDefault` from the cache.
  ///
  /// If the key does not exist, the default value `100` is returned.
  int get nullableCounterWithDefault {
    try {
      return _prefs.getInt('nullableCounterWithDefault') ?? 100;
    } catch (e, s) {
      developer.log(
        'Read error for key "nullableCounterWithDefault"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('nullableCounterWithDefault', e);
      return 100;
    }
  }

  /// Asynchronously sets the value for `nullableCounterWithDefault`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setNullableCounterWithDefault(int? value) {
    if (value == null) {
      return _prefs.remove('nullableCounterWithDefault');
    }
    return _prefs.setInt('nullableCounterWithDefault', value);
  }

  /// Checks if a value has been explicitly set for `nullableCounterWithDefault`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsNullableCounterWithDefault() {
    return _prefs.containsKey('nullableCounterWithDefault');
  }

  /// Removes the stored value for `nullableCounterWithDefault`.
  ///
  /// After calling this, the getter will return the default value (`100`).
  Future<void> removeNullableCounterWithDefault() {
    return _prefs.remove('nullableCounterWithDefault');
  }

  /// Gets the value for `lastSyncDate` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  DateTime? get lastSyncDate {
    try {
      final raw = _prefs.getString('lastSyncDate');
      if (raw == null) return null;
      return DateTime.parse(raw);
    } catch (e, s) {
      developer.log(
        'Read error for key "lastSyncDate"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('lastSyncDate', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `lastSyncDate`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setLastSyncDate(DateTime? value) {
    if (value == null) {
      return _prefs.remove('lastSyncDate');
    }
    return _prefs.setString('lastSyncDate', value.toIso8601String());
  }

  /// Checks if a value has been explicitly set for `lastSyncDate`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsLastSyncDate() {
    return _prefs.containsKey('lastSyncDate');
  }

  /// Removes the stored value for `lastSyncDate`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeLastSyncDate() {
    return _prefs.remove('lastSyncDate');
  }

  /// Gets the value for `lastLoginDate` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  DateTime? get lastLoginDate {
    try {
      final raw = _prefs.getInt('lastLoginDate');
      if (raw == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(raw);
    } catch (e, s) {
      developer.log(
        'Read error for key "lastLoginDate"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('lastLoginDate', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `lastLoginDate`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setLastLoginDate(DateTime? value) {
    if (value == null) {
      return _prefs.remove('lastLoginDate');
    }
    return _prefs.setInt('lastLoginDate', value.millisecondsSinceEpoch);
  }

  /// Checks if a value has been explicitly set for `lastLoginDate`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsLastLoginDate() {
    return _prefs.containsKey('lastLoginDate');
  }

  /// Removes the stored value for `lastLoginDate`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeLastLoginDate() {
    return _prefs.remove('lastLoginDate');
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
      _prefs.remove('displayGreeting'),
      _prefs.remove('pi'),
      _prefs.remove('isWelcomeScreenDone'),
      _prefs.remove('greeting'),
      _prefs.remove('tagList'),
      _prefs.remove('recentItemIds'),
      _prefs.remove('priceHistory'),
      _prefs.remove('sessionId'),
      _prefs.remove('lastLoginTimestamp'),
      _prefs.remove('nullableCounterWithDefault'),
      _prefs.remove('lastSyncDate'),
      _prefs.remove('lastLoginDate'),
    ]);
  }
}
