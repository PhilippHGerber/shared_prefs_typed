/// The access mode for a generated `@TypedPrefs` class.
enum PrefsMode {
  /// Use `SharedPreferencesWithCache` — synchronous, cached getters.
  ///
  /// Reads are served from an in-memory cache populated at startup.
  /// Ideal for frequent reads in performance-sensitive UI code.
  cached,

  /// Use `SharedPreferencesAsync` — asynchronous getters.
  ///
  /// Every read fetches the value from the platform's persistent storage.
  /// Useful when values may be changed by other isolates or native code.
  async,
}
