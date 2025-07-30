# Changelog

All notable changes to this project will be documented in this file.

## 0.5.2

* Fixed supported plattforms

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
