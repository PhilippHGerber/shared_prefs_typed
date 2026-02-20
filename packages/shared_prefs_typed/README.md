# shared_prefs_typed

A code generator that creates a type-safe API for `shared_preferences`, eliminating boilerplate and runtime errors. It supports both modern access patterns: choose **synchronous, cached reads** (via `SharedPreferencesWithCache`) for UI speed or **fully asynchronous reads** (via `SharedPreferencesAsync`) for data consistency.

## Features

* **Type-Safe by Default**: Automatically generates code for strongly-typed access to your preferences, eliminating runtime type errors.
* **Boilerplate Reduction**: Define your preferences once in a simple schema, and the code generator handles the rest.
* **Easy to Use**: Simple singleton API for reading and writing preferences.
* **Maintainable**: Centralized preference definitions make your codebase cleaner and easier to manage.
* **Testable by Design**: Easily mock preferences in your tests without changing production code.

## 🚀 Installation

Run the following commands in your terminal to add the necessary packages:

```sh
# Adds the annotations package to your dependencies
flutter pub add shared_prefs_typed_annotations

# Adds the builder and generator to your dev_dependencies
flutter pub add --dev build_runner shared_prefs_typed
```

## 💡 Usage

### 1. Define Your Preferences Schema

Create a Dart file (e.g., `lib/app_preferences.dart`) and define your preferences using an abstract class annotated with `@TypedPrefs()`.

The supported field types are: `int`, `double`, `bool`, `String`, `List<String>`, `List<int>`, `List<double>`, `List<bool>`, `List<Enum>`, `DateTime` (via `@PrefDateTime`), and any `Enum` type — plus nullable variants of each.

```dart
// lib/app_preferences.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

part 'app_preferences.g.dart';

@TypedPrefs()
abstract class AppPreferences {
  // Primitives with defaults
  static const int counter = 0;
  static const bool isDarkMode = false;
  static const String greeting = 'Hello';

  // Lists — numeric lists are transparently stored as List<String>
  static const List<String> tagList = ['default'];
  static const List<int> recentItemIds = <int>[];
  static const List<double> priceHistory = <double>[9.99, 14.99];

  // Nullable — returns null when the key is absent
  static const String? username = null;

  // Nullable with non-null default — getter returns non-nullable int
  static const int? retryCount = 3;
}
```

> **Naming:** A public class `Foo` generates `FooImpl`; a private class `_Foo` generates `Foo`. Fields must be `static const`.
>
> **Nullable with non-null default:** When a field is `T?` but has a non-null default (e.g. `int? retryCount = 3`), the getter returns `T` (non-nullable). The setter still accepts `T?` so passing `null` removes the key and reverts to the default.

### 2. Run the Code Generator

```bash
flutter pub run build_runner build
```

This generates `app_preferences.g.dart` containing your `AppPreferencesImpl` service class.

---

## 🟢 Simple Usage — Singleton

**Best for:** Small/medium apps with a single entrypoint.

Call `await AppPreferencesImpl.init()` once at startup; then read values synchronously from anywhere via `AppPreferencesImpl.instance`.

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'app_preferences.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferencesImpl.init();
  runApp(const MyApp());
}

// Anywhere in the app — no context needed:
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = AppPreferencesImpl.instance;

    return FloatingActionButton(
      // Getters are synchronous
      child: Text('${prefs.counter}'),
      // Setters are always async
      onPressed: () => prefs.setCounter(prefs.counter + 1),
    );
  }
}
```

`init()` is safe to call multiple times — concurrent callers share the same `Future` and no double-initialization occurs.

### Generated API

For every field `foo` of type `T`, the generator produces:

| Method | Returns | Description |
| --- | --- | --- |
| `foo` (getter) | `T` | Reads the cached value; returns the default if unset. |
| `setFoo(T value)` | `Future<void>` | Persists a new value. Pass `null` to remove (nullable fields only). |
| `containsFoo()` | `bool` | Returns `true` if the key exists in persistent storage. |
| `removeFoo()` | `Future<void>` | Removes the key; subsequent reads return the default. |
| `clearAll()` | `Future<void>` | Removes **all** keys owned by this class. Use instead of wiping the entire store. |

> `resetInstance()` is annotated `@visibleForTesting` — it exists for test teardown only and should not be called from production code.

### Initialization patterns

**Singleton** — call `init()` once at startup and read values via `instance`:

```dart
await AppPreferencesImpl.init();
// ...
AppPreferencesImpl.instance.counter;
```

**Injection** — `init()` also returns the instance, making it easy to wire into a DI container or pass to `runApp` directly:

```dart
final prefs = await AppPreferencesImpl.init();
runApp(MyApp(prefs: prefs));
```

Both patterns are safe to use concurrently — repeated `init()` calls share the same `Future`.

### Type migration & error observability

When a stored value cannot be cast to its expected type (e.g. after a field type change between app versions), the generated getter silently falls back to the field's default. Two hooks let you observe these events:

**`dart:developer` log** — the catch block emits a log under the `'shared_prefs_typed'` name with the key and exception type. This is a no-op in release builds and visible in Flutter DevTools / Observatory during development.

**`onReadError` callback** — pass it at construction time (or via `init()`) to forward errors to a crash reporter:

```dart
// Via singleton init:
await AppPreferencesImpl.init(
  onReadError: (key, error) {
    FirebaseCrashlytics.instance.recordError(error, null, reason: 'prefs read "$key"');
  },
);

// Via constructor (DI pattern):
final prefs = AppPreferencesImpl(backend, onReadError: (key, error) {
  FirebaseCrashlytics.instance.recordError(error, null, reason: 'prefs read "$key"');
});
```

The callback is scoped to the instance — different instances can have different handlers, and tests never bleed state into each other.

To verify the guard in tests:

```dart
Object? capturedError;
final prefs = AppPreferencesImpl(backend, onReadError: (key, error) {
  capturedError = error;
});
// ...
expect(capturedError, isA<ArgumentError>());
```

### Async mode

Use `@TypedPrefs(mode: PrefsMode.async)` when preferences can be modified from another isolate or native code and you always need the freshest value from disk. Getters return `Future`s instead of plain values.

```dart
@TypedPrefs(mode: PrefsMode.async)
abstract class AsyncPrefs {
  static const int pingCount = 0;
}

// Usage:
final count = await prefs.pingCount;     // Future getter
await prefs.setPingCount(count + 1);
```

---

## 🔵 Advanced Usage — DI & Testing

**Best for:** Large apps, testable architectures, and any test file that needs isolated preference state.

The generated class exposes a **public `const` constructor** that accepts the storage backend directly. This is the preferred pattern for both dependency injection and testing: pass a real or in-memory backend explicitly, touch no global state.

```dart
final backend = await SharedPreferencesWithCache.create(
  cacheOptions: const SharedPreferencesWithCacheOptions(),
);

// No init() call needed — no global singleton touched.
final prefs = AppPreferencesImpl(backend);
```

### Testing

Pass a backend built on `InMemorySharedPreferencesAsync` — no platform channel, no singleton cleanup, each test gets a completely isolated instance:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';
import 'package:my_app/app_preferences.g.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });

  late AppPreferencesImpl prefs;

  setUp(() async {
    // Clear the in-memory store between tests.
    await SharedPreferencesAsyncPlatform.instance?.clear(
      const ClearPreferencesParameters(filter: PreferencesFilters()),
      const SharedPreferencesOptions(),
    );
    final backend = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    // Construct directly — no global state touched.
    prefs = AppPreferencesImpl(backend);
  });

  tearDown(AppPreferencesImpl.resetInstance);

  test('counter returns default and can be set', () async {
    expect(prefs.counter, 0);
    await prefs.setCounter(42);
    expect(prefs.counter, 42);
  });
}
```

### Dependency Injection

The constructor integrates naturally with any DI framework.

**GetIt (simple — no interface):**

```dart
final backend = await SharedPreferencesWithCache.create(
  cacheOptions: const SharedPreferencesWithCacheOptions(),
);
getIt.registerSingleton<AppPreferencesImpl>(AppPreferencesImpl(backend));
```

**GetIt with interface (recommended for testability)** — add `generateInterface: true` to generate `AppPreferencesBase`. Production code depends only on the abstract base and is trivially mockable with Mocktail:

```dart
// Schema
@TypedPrefs(generateInterface: true)
abstract class AppPreferences { ... }

// Startup
getIt.registerSingleton<AppPreferencesBase>(AppPreferencesImpl(backend));

// Everywhere else
getIt<AppPreferencesBase>().counter

// Mocktail mock in tests
class MockAppPreferences extends Mock implements AppPreferencesBase {}
```

**Riverpod:**

```dart
final appPrefsProvider = Provider<AppPreferencesImpl>((ref) {
  return AppPreferencesImpl(ref.read(sharedPrefsBackendProvider));
});
```

For a full working example see [`example/advanced`](../../example/advanced) in the repository (counter + dark-mode toggle + username, registered via `AppPreferencesBase`).

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

## Performance Considerations

`List<int>`, `List<double>`, `List<bool>`, and `List<Enum>` fields are serialized as `List<String>` under the hood — elements are converted on write and parsed back on read. This is transparent but has two implications:

* **Keep lists small.** `SharedPreferences` (and its underlying platform storage) is designed for small scalar values. Storing hundreds or thousands of elements in a single key will cause noticeable I/O and parse overhead. For large collections, use a proper database (`sqflite`, `isar`, etc.) instead.
* **No partial updates.** Every `setFoo(list)` call rewrites the entire serialized string. Frequent mutations of a large list are expensive.

`List<String>` does not pay a serialization cost (it is stored natively), but the same size guidance applies.

---

## Out of Scope

This package intentionally does **not** cover the following scenarios:

* **Encryption / secure storage** — use [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage) for sensitive data.
* **Complex/nested object serialization** — only primitives, enums, `DateTime`, and `List<T>` of primitives are supported. For structured data models, consider [`hive`](https://pub.dev/packages/hive) or [`isar`](https://pub.dev/packages/isar).
* **Reactive/stream-based change notifications** — getters return point-in-time values; no `Stream` or `ValueNotifier` is emitted.
* **Multi-isolate write synchronization** — two instances with separate caches on different isolates will diverge. Only the singleton pattern (single isolate) is safe.
* **Cloud or remote backend adapters** — this package wraps local `SharedPreferences` only.

---

## 🤔 Why `shared_prefs_typed`?

Traditional `shared_preferences` usage often involves:

* **Manual Key Management**: Remembering string keys for each preference.
* **Boilerplate Code**: Writing repetitive `get` and `set` methods with type casting.
* **Runtime Errors**: Potential `CastError` if you retrieve a preference with the wrong type.

`shared_prefs_typed` solves these problems by:

* **Centralizing Definitions**: All your preferences are defined in one place.
* **Automating Code Generation**: The `build_runner` generates all the necessary `get` and `set` methods with correct types.
* **Compile-Time Safety**: Type errors are caught during development, not at runtime.

## 🤝 Contributing

Contributions are welcome! Please feel free to open an issue or submit a pull request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
