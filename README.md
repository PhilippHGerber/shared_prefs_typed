# `shared_prefs_typed`: Type-Safe SharedPreferences for Dart & Flutter

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![pub package](https://img.shields.io/pub/v/shared_prefs_typed?color=FFB515)](https://pub.dev/packages/shared_prefs_typed)

`shared_prefs_typed` is a `build_runner` code generator that creates a type-safe, boilerplate-free API for `SharedPreferences`. It eliminates manual key management and runtime type errors by generating a clean, reliable persistence layer from a simple annotated schema class.

```dart
// You write this...
@TypedPrefs()
abstract class AppPreferences {
  static const int counter = 0;
  static const String? username = null;
  static const bool isDarkMode = false;
}

// ...and use this (generated):
await AppPreferencesImpl.init();
prefs.counter;               // int — sync, type-safe
await prefs.setCounter(42);  // Future<void>
prefs.isSetUsername();       // bool
await prefs.removeUsername();
```

---

## Packages

| Package | Description | Version |
|---|---|---|
| **`shared_prefs_typed`** | The `build_runner` generator that creates your type-safe classes. | [![pub package](https://img.shields.io/pub/v/shared_prefs_typed?color=FFB515)](https://pub.dev/packages/shared_prefs_typed) |
| **`shared_prefs_typed_annotations`** | Provides the `@TypedPrefs` annotation to mark your schema classes. | [![pub package](https://img.shields.io/pub/v/shared_prefs_typed_annotations?color=73D3FF)](https://pub.dev/packages/shared_prefs_typed_annotations) |
| **`example/basic`** | A Flutter app demonstrating direct dependency injection and all supported types. | — |
| **`example/advanced`** | A Flutter app demonstrating interface generation with `get_it`. | — |

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  shared_prefs_typed_annotations: ^0.7.0

dev_dependencies:
  build_runner: ^2.11.1
  shared_prefs_typed: ^0.7.0
```

---

## Quick Start

### 1. Define your schema

Create an abstract class annotated with `@TypedPrefs()`. Fields must be `static const` with compile-time defaults:

```dart
// lib/app_preferences.dart
import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

@TypedPrefs()
abstract class AppPreferences {
  static const int counter = 0;
  static const double pi = 3.14;
  static const bool isWelcomeScreenDone = false;
  static const String greeting = 'Hello';
  static const List<String> tagList = ['default'];
  static const String? sessionId = null;  // nullable — no default
}
```

> **Naming:** A public class `Foo` generates `FooImpl`; a private class `_Foo` generates `Foo`.
> Fields must be `static const`.

### 2. Run the generator

```sh
flutter pub run build_runner build
```

This produces `lib/app_preferences.g.dart` containing the `AppPreferencesImpl` class.

### 3. Initialize and use

```dart
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create the backend, then pass it to the generated class
  final backend = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );
  final prefs = AppPreferencesImpl(backend);

  runApp(MyApp(prefs: prefs));
}
```

```dart
// In your widget:
prefs.counter;                     // int (sync)
await prefs.setCounter(prefs.counter + 1);
prefs.isSetSessionId();            // bool
await prefs.removeSessionId();
```

---

## Annotation Options

### `@TypedPrefs(async: true)` — Async mode

By default, the generator uses `SharedPreferencesWithCache` for synchronous reads. Pass `async: true` to use `SharedPreferencesAsync` instead, which returns `Future`s for all getters:

```dart
@TypedPrefs(async: true)
abstract class AppPreferences {
  static const int counter = 0;
}

// Generated:
Future<int> get counter async { ... }
Future<bool> isSetCounter() async { ... }
```

The `init()` call remains identical between modes.

### `@TypedPrefs(generateInterface: true)` — Interface generation

Generates an abstract `${ClassName}Base` interface alongside the concrete class. This is recommended for projects using dependency injection frameworks or that need to mock preferences in tests:

```dart
@TypedPrefs(generateInterface: true)
abstract class AppPreferences {
  static const int counter = 0;
  static const bool isDarkMode = false;
}
```

Generated output includes both `AppPreferencesBase` (abstract interface) and `AppPreferencesImpl` (implements it).

**Usage with `get_it`:**

```dart
// setup
getIt.registerSingleton<AppPreferencesBase>(AppPreferencesImpl(backend));

// usage
getIt<AppPreferencesBase>().counter;
```

**Usage with Mockito/Mocktail:**

```dart
class MockPrefs extends Mock implements AppPreferencesBase {}

final prefs = MockPrefs();
when(() => prefs.counter).thenReturn(42);
```

---

## Supported Field Types

| Type | Nullable |
|---|---|
| `int` | `int?` |
| `double` | `double?` |
| `bool` | `bool?` |
| `String` | `String?` |
| `List<String>` | *(not supported)* |
| `List<int>` | *(not supported)* |
| `List<double>` | *(not supported)* |

> **Nullable with non-null default:** If a field is declared `int?` but given a non-null default (e.g. `static const int? retryCount = 3`), the getter returns the non-nullable type `int`. The setter still accepts `int?` so passing `null` removes the key.

Unsupported types produce a build-time error.

---

## Generated API

For each field `foo` of type `T`, the generator creates four members:

| Member | Sync mode | Async mode |
|---|---|---|
| Getter | `T get foo` | `Future<T> get foo` |
| Setter | `Future<void> setFoo(T value)` | `Future<void> setFoo(T value)` |
| Existence check | `bool isSetFoo()` | `Future<bool> isSetFoo()` |
| Remover | `Future<void> removeFoo()` | `Future<void> removeFoo()` |

For nullable fields, calling the setter with `null` removes the key (equivalent to `removeFoo()`).

The generated class also exposes:

| Member | Description |
|---|---|
| `AppPreferencesImpl(prefs)` | Public constructor for dependency injection |
| `AppPreferencesImpl.instance` | Static accessor — throws `StateError` if not initialized via `init()` |
| `static Future<void> init()` | Creates backend and sets the singleton instance |
| `static void resetInstance()` | Clears the singleton — use in test teardown |

---

## Testing

The generated class is designed for testability. Use `InMemorySharedPreferencesAsync` as a backend to avoid platform dependencies:

```dart
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

late AppPreferencesImpl prefs;

setUp(() async {
  SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  final backend = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );
  prefs = AppPreferencesImpl(backend);
});

tearDown(() => AppPreferencesImpl.resetInstance());

test('counter starts at default', () {
  expect(prefs.counter, 0);
});
```

---

## Renaming Fields & Data Migration

Storage keys are derived from field names by default. **Renaming a field silently changes its storage key**, causing previously saved data to become inaccessible — the getter returns the default value as if the key was never set. No error is thrown.

Use `@PrefKey` to pin the storage key when renaming a field:

```dart
// Before rename:
static const int loginCount = 0;  // key: 'loginCount'

// After rename — @PrefKey preserves the original key:
@PrefKey('loginCount')
static const int signInCount = 0;  // key: still 'loginCount'
```

`build_runner` cannot detect key renames — it is the developer's responsibility to add `@PrefKey` before renaming.

---

## Out of Scope

This package intentionally does **not** cover the following scenarios:

* **Encryption / secure storage** — use [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage) for sensitive data.
* **Complex/nested object serialization** — only primitives, enums, `DateTime`, and `List<T>` of primitives are supported. For structured data models, consider [`hive`](https://pub.dev/packages/hive) or [`isar`](https://pub.dev/packages/isar).
* **Reactive/stream-based change notifications** — getters return point-in-time values; no `Stream` or `ValueNotifier` is emitted.
* **Multi-isolate write synchronization** — two instances with separate caches on different isolates will diverge. Only the singleton pattern (single isolate) is safe.
* **Cloud or remote backend adapters** — this package wraps local `SharedPreferences` only.

---

## 🤝 Contributing

Contributions are welcome! Please open an issue to discuss a new feature or bug before submitting a pull request.

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
