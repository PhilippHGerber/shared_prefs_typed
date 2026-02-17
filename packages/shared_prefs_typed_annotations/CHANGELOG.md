# Changelog

All notable changes to this package will be documented in this file.

## 0.5.3

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
