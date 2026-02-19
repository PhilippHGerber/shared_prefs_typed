// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.
// ignore_for_file: unused_element, unused_field

import 'package:shared_preferences/shared_preferences.dart';

import 'app_preferences.dart';

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
  const AppPreferencesImpl(this._prefs);

  static AppPreferencesImpl? _instance;

  static Future<AppPreferencesImpl>? _initFuture;

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
  static Future<AppPreferencesImpl> init() {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit();
  }

  static Future<AppPreferencesImpl> _doInit() async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = AppPreferencesImpl(prefs);
    } catch (e) {
      _initFuture = null;
      rethrow;
    }
  }

  /// Resets the singleton instance to `null`. Useful for test teardown.
  static void resetInstance() {
    _instance = null;
    _initFuture = null;
  }

  /// Gets the value for `counter` from the cache.
  ///
  /// If the key does not exist, the default value `0` is returned.
  int get counter {
    return _prefs.getInt('counter') ?? 0;
  }

  /// Asynchronously sets the value for `counter`.
  Future<void> setCounter(int value) {
    return _prefs.setInt('counter', value);
  }

  /// Checks if a value has been explicitly set for `counter`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetCounter() {
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
    return _prefs.getString('displayGreeting');
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
  bool isSetDisplayGreeting() {
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
    return _prefs.getDouble('pi') ?? 3.14;
  }

  /// Asynchronously sets the value for `pi`.
  Future<void> setPi(double value) {
    return _prefs.setDouble('pi', value);
  }

  /// Checks if a value has been explicitly set for `pi`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetPi() {
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
    return _prefs.getBool('isWelcomeScreenDone') ?? false;
  }

  /// Asynchronously sets the value for `isWelcomeScreenDone`.
  Future<void> setIsWelcomeScreenDone(bool value) {
    return _prefs.setBool('isWelcomeScreenDone', value);
  }

  /// Checks if a value has been explicitly set for `isWelcomeScreenDone`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetIsWelcomeScreenDone() {
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
    return _prefs.getString('greeting') ?? 'Hello';
  }

  /// Asynchronously sets the value for `greeting`.
  Future<void> setGreeting(String value) {
    return _prefs.setString('greeting', value);
  }

  /// Checks if a value has been explicitly set for `greeting`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetGreeting() {
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
    return _prefs.getStringList('tagList') ?? const <String>['default'];
  }

  /// Asynchronously sets the value for `tagList`.
  Future<void> setTagList(List<String> value) {
    return _prefs.setStringList('tagList', value);
  }

  /// Checks if a value has been explicitly set for `tagList`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool isSetTagList() {
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
    final raw = _prefs.getStringList('recentItemIds');
    return raw == null ? const <int>[] : raw.map(int.parse).toList();
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
  bool isSetRecentItemIds() {
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
    final raw = _prefs.getStringList('priceHistory');
    return raw == null
        ? const <double>[9.99, 14.99, 19.99]
        : raw.map(double.parse).toList();
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
  bool isSetPriceHistory() {
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
    return _prefs.getString('sessionId');
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
  bool isSetSessionId() {
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
    return _prefs.getInt('lastLoginTimestamp');
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
  bool isSetLastLoginTimestamp() {
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
    return _prefs.getInt('nullableCounterWithDefault') ?? 100;
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
  bool isSetNullableCounterWithDefault() {
    return _prefs.containsKey('nullableCounterWithDefault');
  }

  /// Removes the stored value for `nullableCounterWithDefault`.
  ///
  /// After calling this, the getter will return the default value (`100`).
  Future<void> removeNullableCounterWithDefault() {
    return _prefs.remove('nullableCounterWithDefault');
  }
}
