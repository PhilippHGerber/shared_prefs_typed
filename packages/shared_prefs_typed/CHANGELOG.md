# Changelog

All notable changes to this project will be documented in this file.

## 0.6.1

* Fixed README.md

## 0.6.0

**Breaking change** — re-run `flutter pub run build_runner build` after upgrading. No user code changes required unless you accessed `_prefs` directly (which was private and unsupported).

### New

* Generated class now has a **public constructor** that accepts the storage backend directly (`AppPreferences(prefs)`). Enables constructor injection for DI frameworks (GetIt, Riverpod, provider) and clean per-test instances.
* `static AppPreferences? _instance` replaces the old eager `static final instance`. The `instance` getter now throws a descriptive `StateError` before `init()` instead of a `LateInitializationError`.
* **`resetInstance()`** static method resets `_instance` to `null` for test teardown.
* **`generateInterface: true`** annotation option generates an abstract `AppPreferencesBase` class. Enables typed DI registrations and Mockito/Mocktail mocks without touching the concrete class.
* Async-mode `init()` is now synchronous internally (no `await`) while preserving its `Future<void>` return type.

### Migration

After upgrading, run:

```bash
flutter pub run build_runner build
```

The `init()` / `instance` API is fully backward compatible.

### Fixed

* **Fix**: Removed redundant `?? null` from generated nullable getters
* **Fix**: Removed unnecessary `as TypeName` casts in generated nullable setters
* **Fix**: Unsupported field types now produce a clear build-time error instead of uncompilable code
* **Fix**: Improved string escaping for default values (handles `\`, `$`, newlines)
* **Fix**: Removed redundant `return;` from generated async `init()` method
* Removed unused dependencies (`meta`, `build_config`)
* Added async mode and error case generator tests

## 0.5.2

* Fixed supported platforms

## 0.5.1

* Fixed builder config

## 0.5.0

2025-07-25

### Initial Release

This is the first release of `shared_prefs_typed`.

* **Type-Safe Code Generation**: Automatically generates a singleton service class for accessing `SharedPreferences` based on a simple, abstract schema class.
* **Dual Access Modes**:
  * **Synchronous Getters (Default)**: Provides fast, synchronous getters for performance-critical access (e.g., UI code).
  * **Asynchronous Getters (`async: true`)**: Provides `Future`-based getters for cases where data may be updated externally.
* **Full Type Support**: Supports all types allowed by `shared_preferences`: `int`, `double`, `bool`, `String`, `List<String>`, and their **nullable variants**.
* **Boilerplate Reduction**: Eliminates the need for manual key management and repetitive `get`/`set` methods.
* **Testable by Design**: Integrates seamlessly with `shared_preferences_platform_interface` for easy and reliable testing.
