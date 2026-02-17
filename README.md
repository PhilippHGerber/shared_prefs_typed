# `shared_prefs_typed`: Type-Safe SharedPreferences for Dart & Flutter

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![pub package](https://img.shields.io/pub/v/shared_prefs_typed?color=FFB515)](https://pub.dev/packages/shared_prefs_typed)

`shared_prefs_typed` is a `build_runner` code generator that creates a type-safe, boilerplate-free API for `SharedPreferences`. It eliminates manual key management and runtime type errors by generating a clean, reliable persistence layer from a simple annotated schema class.

```dart
// You write this...
@TypedPrefs()
abstract class _AppPreferences {
  static const int counter = 0;
  static const String? username = null;
  static const bool isDarkMode = false;
}

// ...and use this (generated):
await AppPreferences.init();
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
  shared_prefs_typed_annotations: ^0.6.0

dev_dependencies:
  build_runner: ^2.11.1
  shared_prefs_typed: ^0.6.0
```

---

## Quick Start

### 1. Define your schema

Create a private abstract class annotated with `@TypedPrefs()`. Fields must be `static const` with compile-time defaults:

```dart
// lib/app_preferences.dart
import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

@TypedPrefs()
abstract class _AppPreferences {
  static const int counter = 0;
  static const double pi = 3.14;
  static const bool isWelcomeScreenDone = false;
  static const String greeting = 'Hello';
  static const List<String> tagList = ['default'];
  static const String? sessionId = null;  // nullable — no default
}
```

> **Rules:** The class name must start with `_`. Fields must be `static const`.

### 2. Run the generator

```sh
dart run build_runner build
```

This produces `lib/app_preferences.g.dart` containing the `AppPreferences` class.

### 3. Initialize and use

```dart
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create the backend, then pass it to the generated class
  final backend = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );
  final prefs = AppPreferences(backend);

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
abstract class _AppPreferences {
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
abstract class _AppPreferences {
  static const int counter = 0;
  static const bool isDarkMode = false;
}
```

Generated output includes both `AppPreferencesBase` (abstract interface) and `AppPreferences` (implements it).

**Usage with `get_it`:**

```dart
// setup
getIt.registerSingleton<AppPreferencesBase>(AppPreferences(backend));

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
| `AppPreferences(prefs)` | Public constructor for dependency injection |
| `AppPreferences.instance` | Static accessor — throws `StateError` if not initialized via `init()` |
| `static Future<void> init()` | Creates backend and sets the singleton instance |
| `static void resetInstance()` | Clears the singleton — use in test teardown |

---

## Testing

The generated class is designed for testability. Use `InMemorySharedPreferencesAsync` as a backend to avoid platform dependencies:

```dart
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

late AppPreferences prefs;

setUp(() async {
  SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  final backend = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );
  prefs = AppPreferences(backend);
});

tearDown(() => AppPreferences.resetInstance());

test('counter starts at default', () {
  expect(prefs.counter, 0);
});
```

---

## 🤝 Contributing

Contributions are welcome! Please open an issue to discuss a new feature or bug before submitting a pull request.

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
