# Changelog

All notable changes to this project will be documented in this file.

## 1.0.1

### Fixed

* **Uniform Read Error Boundaries**: All preference getters (`int`, `double`, `bool`, `String`, `List<String>`, `List<int>`, `List<double>`, `List<bool>`, `List<Enum>`, `DateTime` millis/ISO-8601) now safely catch both storage type mismatches and parse errors within a uniform `try/catch` boundary, returning compile-time defaults instead of throwing uncaught exceptions.
* **Dual Observability**: Every read failure automatically logs diagnostics to `developer.log` under the `'shared_prefs_typed'` name (with error and stack trace) and triggers the optional `onReadError` callback.
* **Async `init()` Error Recovery**: Failed asynchronous initializations now reset `_initFuture = null`, allowing subsequent `init()` attempts to retry cleanly without requiring a process restart.

### New

* **Build-Time Import Validation**: The generator now verifies that `dart:developer` is imported in schema files and provides actionable error guidance if missing.
* **Expanded Reserved Member Validation**: Added build-time conflict validation for `init`, `instance`, `resetInstance`, `clearAll`, `prefs`, `initFuture`, and `onReadError`.

### Docs

* Clarified that `init(onReadError: ...)` captures `onReadError` during the initial `init()` call only.
* Documented `developer.log` error logging and unmodifiable list copy-modify-set patterns.
* Removed obsolete `const` constructor claims.

### Changed

* Raised minimum Dart SDK to `^3.13.0` and `analyzer` to `^13.3.0`.

### Internal

* Unified sync/async code generation for getters, setters, and class scaffolding into single functions parameterised by `isAsync`, and moved type dispatch into `SharedPrefField`.

## 1.0.0

### Breaking

* **Generated files are now `part` files** — add `part 'filename.g.dart';` to your schema file (below your imports). Without this directive the build will fail. See the README Quick Start for the updated template.
* **`onReadError` is now a constructor parameter** — pass it at construction time: `ClassName(backend, onReadError: cb)` or `ClassName.init(onReadError: cb)`.
* **`@TypedPrefs(async: true)` removed** — use `@TypedPrefs(mode: PrefsMode.async)`.
* **`XxxImplBase` renamed to `XxxBase`** — update DI registrations, type annotations, and mocks.
* **`isSetFoo()` renamed to `containsFoo()`**.
* **`const` removed from generated constructor**
* **`resetInstance()` annotated `@visibleForTesting`**.

### New

* **`List<bool>` support** — stored as `List<String>` (`"true"`/`"false"`).
* **`List<Enum>` support** — stored as `List<String>` via `.name`; read back via `.values.byName` (with crash guard).
* **Non-nullable `DateTime` getters** — via `@PrefDateTime(encoding, defaultMillis: N)`.
* **`clearAll()`** — removes all keys owned by the class.
* **`onReadError` callback** — pass to constructor or `init()` to forward read errors to a crash reporter.
* **`dart:developer` log on read failure** — emitted under the `'shared_prefs_typed'` name; no-op in release builds.

### Fixed

* **Enum getters no longer crash on stale stored values** — `values.byName` is now wrapped in try/catch; returns the default instead of throwing `ArgumentError`.
* **`List<int>` / `List<double>` getters no longer crash on corrupted elements** — `parse` is now wrapped in try/catch; returns the default list instead of throwing `FormatException`.
* **`clearAll()` docstring** — explicitly notes the operation is not atomic.

## 0.7.0

> Re-run `flutter pub run build_runner build`.

### New

* **Reserved name validation** — generator throws a build-time error when a field name collides with a built-in generated member (`init`, `instance`, `resetInstance`). Use `@PrefKey` to assign a different storage key.
* **Non-nullable getter for nullable fields with non-null default** — `static const int? retryCount = 3` generates `int get retryCount` (non-nullable getter, nullable setter). Eliminates `!` at call sites.
* **Public schema classes** — annotated class no longer needs a leading `_`. `_AppPrefs` → `AppPrefs`; `AppPrefs` → `AppPrefsImpl`.
* **Immutable list getters** — all `List<T>` getters return `UnmodifiableListView`. `dart:collection` is only imported when list fields are present.
* **`List<int>` / `List<double>` support** — serialized via `toString()` / `int.parse` / `double.parse`. Nullable variants and typed default literals supported.
* **`@PrefKey('key')`** — overrides the storage key per field. Generator rejects empty and duplicate keys.
* **Enum support** — stored as `.name`, parsed via `.values.byName()`.
* **`DateTime` support** (nullable only) — requires `@PrefDateTime(DateTimeEncoding.millisecondsSinceEpoch)` or `.iso8601`.
* **Public `const` constructor** — `ClassName(prefs)` for DI/testing.
* **Concurrency-safe `init()`** — memoizes the future; safe to call multiple times.
* **`resetInstance()`** — clears both `_instance` and `_initFuture` for test teardown.

### Removed

* `create()` and `fromBackend()` — use `init()` or `ClassName(prefs)`.

### Fixed

* **Type-migration crash** — primitive getters (`int`, `double`, `bool`, `String`, `DateTime` millis) are wrapped in `try/catch`; a `TypeError` on stale storage data returns the field default instead of crashing.
* **Data-loss warning** — generated file includes a header comment noting that renaming a field changes its storage key unless `@PrefKey` pins it.
* `DateTime.parse` wrapped in `try-catch`; returns `null` on malformed data.
* `analyzer` 10.0.1 compatibility — null-check `constantValue.type` before use.

### Docs

* Added "Renaming Fields & Data Migration" and "Out of Scope" sections to the README.

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
