// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

// ignore_for_file: unnecessary_cast, unused_element, unused_field

import 'package:shared_preferences/shared_preferences.dart';

import 'app_preferences.dart';

/// Provides type-safe, cached access to application preferences.
///
/// Use `await AppPreferences.init()` on app startup,
/// then access values via the singleton `instance`.
class AppPreferences {
  AppPreferences._();

  static final instance = AppPreferences._();

  static late SharedPreferencesWithCache _prefs;

  /// Initializes the preferences service.
  static Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
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
    return _prefs.getString('displayGreeting') ?? null;
  }

  /// Asynchronously sets the value for `displayGreeting`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setDisplayGreeting(String? value) {
    if (value == null) {
      return _prefs.remove('displayGreeting');
    }
    return _prefs.setString('displayGreeting', value as String);
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

  /// Gets the value for `sessionId` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  String? get sessionId {
    return _prefs.getString('sessionId') ?? null;
  }

  /// Asynchronously sets the value for `sessionId`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setSessionId(String? value) {
    if (value == null) {
      return _prefs.remove('sessionId');
    }
    return _prefs.setString('sessionId', value as String);
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
    return _prefs.getInt('lastLoginTimestamp') ?? null;
  }

  /// Asynchronously sets the value for `lastLoginTimestamp`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setLastLoginTimestamp(int? value) {
    if (value == null) {
      return _prefs.remove('lastLoginTimestamp');
    }
    return _prefs.setInt('lastLoginTimestamp', value as int);
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
  int? get nullableCounterWithDefault {
    return _prefs.getInt('nullableCounterWithDefault') ?? 100;
  }

  /// Asynchronously sets the value for `nullableCounterWithDefault`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setNullableCounterWithDefault(int? value) {
    if (value == null) {
      return _prefs.remove('nullableCounterWithDefault');
    }
    return _prefs.setInt('nullableCounterWithDefault', value as int);
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
