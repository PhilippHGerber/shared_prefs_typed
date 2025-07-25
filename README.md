# `shared_prefs_typed`: Type-Safe SharedPreferences for Dart & Flutter

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

`shared_prefs_typed` is a code generator for Dart and Flutter that creates a type-safe, boilerplate-free API for `SharedPreferences`. It solves the common pitfalls of using `shared_preferences` directly—like manual key management and runtime type errors—by automating the creation of a clean, reliable persistence layer.

This repository is a monorepo containing the core packages and a comprehensive example application.

| Package | Description | Version |
|---|---|---|
| **`shared_prefs_typed`** | The main package containing the `build_runner` generator to create your type-safe classes. | `0.5.0` |
| **`shared_prefs_typed_annotations`** | Provides the `@TypedPrefs` annotation to mark your schemas for code generation. | `0.5.0` |
| **`example`** | A complete Flutter application demonstrating features and best practices, including testing. | `0.5.0` |

---

## 🤝 Contributing

Contributions are welcome! Please feel free to open an issue to discuss a new feature, report a bug, or submit a pull request.

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
