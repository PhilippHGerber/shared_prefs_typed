# Changelog

All notable changes to this package will be documented in this file.

## 1.0.1

### Docs

* Updated `@TypedPrefs` doc comments to clearly document support for both public (`Foo` -> `FooImpl`) and private (`_Foo` -> `Foo`) annotated schema classes.

### Changed

* Raised minimum Dart SDK to `^3.13.0`.

## 1.0.0

### Breaking

* **`@TypedPrefs(async: true)` removed** — the deprecated `async` parameter has been deleted. Replace with `@TypedPrefs(mode: PrefsMode.async)`.

## 0.7.0

### New

* **`@PrefKey(String key)`** — field-level annotation to override the SharedPreferences storage key. Added `@Target({TargetKind.field})`.
* **`@PrefDateTime(DateTimeEncoding encoding)`** — field-level annotation to specify how a `DateTime` field is encoded in storage. Added `@Target({TargetKind.field})`.
* **`DateTimeEncoding` enum** — two variants: `millisecondsSinceEpoch` (stored as `int`) and `iso8601` (stored as `String`).
* **`generateInterface`** parameter added to `TypedPrefs` — when `true`, the generator also produces an abstract `{ClassName}Base` interface.

## 0.6.0

* Added `@Target({TargetKind.classType})` to `TypedPrefs` — misuse on non-class declarations now produces an IDE-level error
* Added `meta` as a dependency
* Improved class-level documentation (documents the `_` prefix requirement)

## 0.5.2

* Fixed supported platforms

## 0.5.1

* Added example file

## 0.5.0

* Initial stable release.
* Provides the `@TypedPrefs` annotation with the optional `async` boolean parameter to control the generator's output mode.
