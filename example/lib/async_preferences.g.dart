// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

// ignore_for_file: unnecessary_cast, unused_element, unused_field

import 'package:shared_preferences/shared_preferences.dart';

import 'async_preferences.dart';

/// Provides type-safe, asynchronous access to application preferences.
///
/// Use `await AsyncPreferences.init()` on app startup,
/// then access values via the singleton `instance`.
class AsyncPreferences {
  AsyncPreferences._();

  static final instance = AsyncPreferences._();

  static late SharedPreferencesAsync _prefs;

  static Future<void> init() async {
    _prefs = SharedPreferencesAsync();
    return;
  }

  /// Asynchronously gets the value for `pingCount`.
  ///
  /// If the key does not exist, the default value `0` is returned.
  Future<int> get pingCount async {
    return (await _prefs.getInt('pingCount')) ?? 0;
  }

  /// Asynchronously sets the value for `pingCount`.
  Future<void> setPingCount(int value) {
    return _prefs.setInt('pingCount', value);
  }

  /// Checks if a value has been explicitly set for `pingCount`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  Future<bool> isSetPingCount() {
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
    return (await _prefs.getString('serverId')) ?? null;
  }

  /// Asynchronously sets the value for `serverId`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setServerId(String? value) {
    if (value == null) {
      return _prefs.remove('serverId');
    }
    return _prefs.setString('serverId', value as String);
  }

  /// Checks if a value has been explicitly set for `serverId`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  Future<bool> isSetServerId() {
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
    return (await _prefs.getBool('isCacheEnabled')) ?? true;
  }

  /// Asynchronously sets the value for `isCacheEnabled`.
  Future<void> setIsCacheEnabled(bool value) {
    return _prefs.setBool('isCacheEnabled', value);
  }

  /// Checks if a value has been explicitly set for `isCacheEnabled`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  Future<bool> isSetIsCacheEnabled() {
    return _prefs.containsKey('isCacheEnabled');
  }

  /// Removes the stored value for `isCacheEnabled`.
  ///
  /// After calling this, the getter will return the default value (`true`).
  Future<void> removeIsCacheEnabled() {
    return _prefs.remove('isCacheEnabled');
  }
}
