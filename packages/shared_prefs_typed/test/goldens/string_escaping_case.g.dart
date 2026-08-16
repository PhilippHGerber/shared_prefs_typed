// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'string_escaping_case.dart';

// **************************************************************************
// TypedPrefsGenerator
// **************************************************************************

/// WARNING: Storage keys are derived from field names. Renaming a field changes its key and causes data loss unless @PrefKey is used to pin the key explicitly.

/// Provides type-safe, cached access to application preferences.
///
/// **Simple apps**: call `await StringEscapingPrefs.init()` on startup,
/// then access values via the singleton `StringEscapingPrefs.instance`.
///
/// **DI & Testing**: inject a backend directly: `StringEscapingPrefs(backend)`.
class StringEscapingPrefs {
  /// Creates an instance backed by the given [SharedPreferencesWithCache].
  ///
  /// Use this for dependency injection and testing.
  /// For global access, use [init] and [instance] instead.
  StringEscapingPrefs(
    this._prefs, {
    void Function(String key, Object error)? onReadError,
  }) : _onReadError = onReadError;

  static StringEscapingPrefs? _instance;

  static Future<StringEscapingPrefs>? _initFuture;

  /// Optional callback invoked when a stored value cannot be cast to its
  /// expected type (e.g. after a field type change between app versions).
  ///
  /// Receives the preference key and the exception. Use this to forward
  /// errors to a crash reporter (Crashlytics, Sentry, etc.).
  final void Function(String key, Object error)? _onReadError;

  final SharedPreferencesWithCache _prefs;

  /// The singleton instance. Throws a [StateError] if [init] has not been called.
  static StringEscapingPrefs get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'StringEscapingPrefs has not been initialized. '
        'Call `await StringEscapingPrefs.init()` before accessing `instance`.',
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
  static Future<StringEscapingPrefs> init({
    void Function(String key, Object error)? onReadError,
  }) {
    if (_instance != null) return Future.value(_instance!);
    return _initFuture ??= _doInit(onReadError: onReadError);
  }

  static Future<StringEscapingPrefs> _doInit({
    void Function(String key, Object error)? onReadError,
  }) async {
    try {
      final prefs = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      return _instance = StringEscapingPrefs(prefs, onReadError: onReadError);
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

  /// Gets the value for `withBackslash` from the cache.
  ///
  /// If the key does not exist, the default value `'path\\to\\file'` is returned.
  String get withBackslash {
    try {
      return _prefs.getString('withBackslash') ?? 'path\\to\\file';
    } catch (e, s) {
      developer.log(
        'Read error for key "withBackslash"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('withBackslash', e);
      return 'path\\to\\file';
    }
  }

  /// Asynchronously sets the value for `withBackslash`.
  Future<void> setWithBackslash(String value) {
    return _prefs.setString('withBackslash', value);
  }

  /// Checks if a value has been explicitly set for `withBackslash`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsWithBackslash() {
    return _prefs.containsKey('withBackslash');
  }

  /// Removes the stored value for `withBackslash`.
  ///
  /// After calling this, the getter will return the default value (`'path\\to\\file'`).
  Future<void> removeWithBackslash() {
    return _prefs.remove('withBackslash');
  }

  /// Gets the value for `withDollarSign` from the cache.
  ///
  /// If the key does not exist, the default value `'cost is \$10'` is returned.
  String get withDollarSign {
    try {
      return _prefs.getString('withDollarSign') ?? 'cost is \$10';
    } catch (e, s) {
      developer.log(
        'Read error for key "withDollarSign"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('withDollarSign', e);
      return 'cost is \$10';
    }
  }

  /// Asynchronously sets the value for `withDollarSign`.
  Future<void> setWithDollarSign(String value) {
    return _prefs.setString('withDollarSign', value);
  }

  /// Checks if a value has been explicitly set for `withDollarSign`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsWithDollarSign() {
    return _prefs.containsKey('withDollarSign');
  }

  /// Removes the stored value for `withDollarSign`.
  ///
  /// After calling this, the getter will return the default value (`'cost is \$10'`).
  Future<void> removeWithDollarSign() {
    return _prefs.remove('withDollarSign');
  }

  /// Gets the value for `withNewline` from the cache.
  ///
  /// If the key does not exist, the default value `'line1\nline2'` is returned.
  String get withNewline {
    try {
      return _prefs.getString('withNewline') ?? 'line1\nline2';
    } catch (e, s) {
      developer.log(
        'Read error for key "withNewline"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('withNewline', e);
      return 'line1\nline2';
    }
  }

  /// Asynchronously sets the value for `withNewline`.
  Future<void> setWithNewline(String value) {
    return _prefs.setString('withNewline', value);
  }

  /// Checks if a value has been explicitly set for `withNewline`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsWithNewline() {
    return _prefs.containsKey('withNewline');
  }

  /// Removes the stored value for `withNewline`.
  ///
  /// After calling this, the getter will return the default value (`'line1\nline2'`).
  Future<void> removeWithNewline() {
    return _prefs.remove('withNewline');
  }

  /// Gets the value for `withTab` from the cache.
  ///
  /// If the key does not exist, the default value `'col1\tcol2'` is returned.
  String get withTab {
    try {
      return _prefs.getString('withTab') ?? 'col1\tcol2';
    } catch (e, s) {
      developer.log(
        'Read error for key "withTab"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('withTab', e);
      return 'col1\tcol2';
    }
  }

  /// Asynchronously sets the value for `withTab`.
  Future<void> setWithTab(String value) {
    return _prefs.setString('withTab', value);
  }

  /// Checks if a value has been explicitly set for `withTab`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsWithTab() {
    return _prefs.containsKey('withTab');
  }

  /// Removes the stored value for `withTab`.
  ///
  /// After calling this, the getter will return the default value (`'col1\tcol2'`).
  Future<void> removeWithTab() {
    return _prefs.remove('withTab');
  }

  /// Gets the value for `withSingleQuote` from the cache.
  ///
  /// If the key does not exist, the default value `'it\'s here'` is returned.
  String get withSingleQuote {
    try {
      return _prefs.getString('withSingleQuote') ?? 'it\'s here';
    } catch (e, s) {
      developer.log(
        'Read error for key "withSingleQuote"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('withSingleQuote', e);
      return 'it\'s here';
    }
  }

  /// Asynchronously sets the value for `withSingleQuote`.
  Future<void> setWithSingleQuote(String value) {
    return _prefs.setString('withSingleQuote', value);
  }

  /// Checks if a value has been explicitly set for `withSingleQuote`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsWithSingleQuote() {
    return _prefs.containsKey('withSingleQuote');
  }

  /// Removes the stored value for `withSingleQuote`.
  ///
  /// After calling this, the getter will return the default value (`'it\'s here'`).
  Future<void> removeWithSingleQuote() {
    return _prefs.remove('withSingleQuote');
  }

  /// Gets the value for `withInterpolation` from the cache.
  ///
  /// If the key does not exist, the default value `'Hello \${world} with \'quotes\''` is returned.
  String get withInterpolation {
    try {
      return _prefs.getString('withInterpolation') ??
          'Hello \${world} with \'quotes\'';
    } catch (e, s) {
      developer.log(
        'Read error for key "withInterpolation"',
        name: 'shared_prefs_typed',
        error: e,
        stackTrace: s,
      );
      _onReadError?.call('withInterpolation', e);
      return 'Hello \${world} with \'quotes\'';
    }
  }

  /// Asynchronously sets the value for `withInterpolation`.
  Future<void> setWithInterpolation(String value) {
    return _prefs.setString('withInterpolation', value);
  }

  /// Checks if a value has been explicitly set for `withInterpolation`.
  ///
  /// Returns `true` if the key exists in persistent storage, `false` otherwise.
  bool containsWithInterpolation() {
    return _prefs.containsKey('withInterpolation');
  }

  /// Removes the stored value for `withInterpolation`.
  ///
  /// After calling this, the getter will return the default value (`'Hello \${world} with \'quotes\''`).
  Future<void> removeWithInterpolation() {
    return _prefs.remove('withInterpolation');
  }

  /// Removes all preferences managed by this class from storage.
  ///
  /// After calling this, all getters return their default values.
  ///
  /// **Note:** This operation is not atomic. Concurrent writes during this
  /// operation may result in keys remaining in storage.
  Future<void> clearAll() {
    return Future.wait([
      _prefs.remove('withBackslash'),
      _prefs.remove('withDollarSign'),
      _prefs.remove('withNewline'),
      _prefs.remove('withTab'),
      _prefs.remove('withSingleQuote'),
      _prefs.remove('withInterpolation'),
    ]);
  }
}
