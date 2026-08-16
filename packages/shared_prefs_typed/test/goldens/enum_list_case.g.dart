// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'enum_list_case.dart';

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await EnumListPrefs.init()` on startup,
/// then access values via the singleton `EnumListPrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `EnumListPrefs(backend)`.
class EnumListPrefs {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  EnumListPrefs(
    this._prefs, {
    void Function(String key, Object error)? onReadError,
  }) : _onReadError = onReadError;

  static EnumListPrefs? _instance;

  static Future<EnumListPrefs>? _initFuture;

  /// Optional callback invoked when a stored value cannot be cast to its
  /// expected type (e.g. after a field type change between app versions).
  ///
  /// Receives the preference key and the exception. Use this to forward
  /// errors to a crash reporter (Crashlytics, Sentry, etc.).
  final void Function(String key, Object error)? _onReadError;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static EnumListPrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'EnumListPrefs has not been initialized. '
        'Call `await EnumListPrefs.init()` before accessing `instance`.',
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
  static Future<EnumListPrefs> init({
    void Function(String key, Object error)? onReadError,
  }) {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit(onReadError: onReadError);
  }

  static Future<EnumListPrefs> _doInit({
    void Function(String key, Object error)? onReadError,
  }) async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = EnumListPrefs(prefs, onReadError: onReadError);
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

  /// Gets the value for `themes` from the cache.
  ///
  /// If the key does not exist, the default value `const <ThemeMode>[ThemeMode.light, ThemeMode.dark]` is returned.
  List<ThemeMode> get themes {
    try {
      final raw = _prefs.getStringList('themes');
      return raw == null
          ? const <ThemeMode>[ThemeMode.light, ThemeMode.dark]
          : List.unmodifiable(raw.map(ThemeMode.values.byName).toList());
    } catch (e, s) {
      developer.log(
        'Read error for key "themes"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('themes', e);
      return const <ThemeMode>[ThemeMode.light, ThemeMode.dark];
    }
  }

  /// Asynchronously sets the value for `themes`.
  Future<void> setThemes(List<ThemeMode> value) {
    return _prefs.setStringList('themes', value.map((e) => e.name).toList());
  }

  /// Checks if a value has been explicitly set for `themes`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsThemes() {
    return _prefs.containsKey('themes');
  }

  /// Removes the stored value for `themes`.
  ///
  /// After calling this, the getter will return the default value (`const <ThemeMode>[ThemeMode.light, ThemeMode.dark]`).
  Future<void> removeThemes() {
    return _prefs.remove('themes');
  }

  /// Gets the value for `priorities` from the cache.
  ///
  /// If the key does not exist, the default value `const <Priority>[Priority.medium]` is returned.
  List<Priority> get priorities {
    try {
      final raw = _prefs.getStringList('priorities');
      return raw == null
          ? const <Priority>[Priority.medium]
          : List.unmodifiable(raw.map(Priority.values.byName).toList());
    } catch (e, s) {
      developer.log(
        'Read error for key "priorities"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('priorities', e);
      return const <Priority>[Priority.medium];
    }
  }

  /// Asynchronously sets the value for `priorities`.
  Future<void> setPriorities(List<Priority> value) {
    return _prefs.setStringList(
      'priorities',
      value.map((e) => e.name).toList(),
    );
  }

  /// Checks if a value has been explicitly set for `priorities`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsPriorities() {
    return _prefs.containsKey('priorities');
  }

  /// Removes the stored value for `priorities`.
  ///
  /// After calling this, the getter will return the default value (`const <Priority>[Priority.medium]`).
  Future<void> removePriorities() {
    return _prefs.remove('priorities');
  }

  /// Gets the value for `optionalThemes` from the cache.
  ///
  /// If the key does not exist, the default value `null` is returned.
  List<ThemeMode>? get optionalThemes {
    try {
      final raw = _prefs.getStringList('optionalThemes');
      return raw == null
          ? null
          : List.unmodifiable(raw.map(ThemeMode.values.byName).toList());
    } catch (e, s) {
      developer.log(
        'Read error for key "optionalThemes"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('optionalThemes', e);
      return null;
    }
  }

  /// Asynchronously sets the value for `optionalThemes`.
  ///
  /// If the provided [value] is `null`, the preference is removed from storage.
  Future<void> setOptionalThemes(List<ThemeMode>? value) {
    if (value == null) {
      return _prefs.remove('optionalThemes');
    }
    return _prefs.setStringList(
      'optionalThemes',
      value.map((e) => e.name).toList(),
    );
  }

  /// Checks if a value has been explicitly set for `optionalThemes`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsOptionalThemes() {
    return _prefs.containsKey('optionalThemes');
  }

  /// Removes the stored value for `optionalThemes`.
  ///
  /// After calling this, the getter will return the default value (`null`).
  Future<void> removeOptionalThemes() {
    return _prefs.remove('optionalThemes');
  }

  /// Removes all preferences managed by this class from storage.
  ///
  /// After calling this, all getters return their default values.
  ///
  /// **Note:** This operation is not atomic. Concurrent writes during this
  /// operation may result in keys remaining in storage.
  Future<void> clearAll() {
    return Future.wait([
      _prefs.remove('themes'),
      _prefs.remove('priorities'),
      _prefs.remove('optionalThemes'),
    ]);
  }
}
