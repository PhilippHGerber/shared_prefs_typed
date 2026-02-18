# shared_prefs_typed - Agent Guide

Type-safe SharedPreferences for Flutter via `build_runner` code generation.

## What It Does

Annotate a **private abstract class** with `@TypedPrefs()` and declare `static const` fields. The generator produces a public class with a shared-instance accessor and typed getters, setters, `isSet` checks, and `remove` methods for each field.

## Setup

Add to `pubspec.yaml`:

```yaml
dependencies:
  shared_preferences: ^2.5.0
  shared_prefs_typed_annotations: ^0.6.0

dev_dependencies:
  build_runner: ^2.4.0
  shared_prefs_typed: ^0.6.0
```

Run code generation:

```bash
flutter pub run build_runner build
```

## Supported Types

`int`, `double`, `bool`, `String`, `List<String>`, `List<int>`, `List<double>` — plus nullable variants (`int?`, `double?`, `bool?`, `String?`).

Also supported: **Enum types** (any Dart enum) and **`DateTime`** (requires `@PrefDateTime` annotation; always nullable).

## Usage Pattern

### 1. Define the schema

Create a file (e.g. `lib/app_preferences.dart`):

```dart
import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

@TypedPrefs()
abstract class _AppPreferences {
  static const int counter = 0;           // default value: 0
  static const String greeting = 'Hello'; // default value: 'Hello'
  static const bool darkMode = false;
  static const String? sessionId = null;  // nullable, no default
  static const List<String> tags = <String>[];
  static const List<int> scores = <int>[];
  @PrefDateTime(DateTimeEncoding.iso8601)
  static const DateTime? lastLogin = null; // DateTime always nullable
  @PrefKey('legacy_theme_key')
  static const ThemeMode theme = ThemeMode.system; // Enum with custom key
}
```

### 2. Generated output (`app_preferences.g.dart`)

The generator creates class `AppPreferences` (leading `_` stripped) with:

- **Constructor**: `const AppPreferences(SharedPreferencesWithCache prefs)` — for DI/testing
- **Singleton**: `static Future<AppPreferences> init()` (concurrency-safe, idempotent) + `static AppPreferences get instance` (throws `StateError` if `init` not called)
- **Teardown**: `static void resetInstance()` — clears both `_instance` and `_initFuture`; use in test teardown
- **Per field** (e.g. `counter`):
  - `int get counter` -- sync getter, returns default if unset
  - `Future<void> setCounter(int value)` -- async setter
  - `bool isSetCounter()` -- checks if key exists
  - `Future<void> removeCounter()` -- removes key

For **nullable** fields, the setter accepts `T?` and calls `remove()` when value is `null`.

### 3. Initialize and use

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();

  final prefs = AppPreferences.instance;
  print(prefs.counter);            // 0 (default)
  await prefs.setCounter(42);
  print(prefs.counter);            // 42
  print(prefs.isSetCounter());     // true
  await prefs.removeCounter();
  print(prefs.counter);            // 0 (back to default)
}
```

## Annotation Options

| Option | Default | Effect |
|---|---|---|
| `async` | `false` | `true` = async getters via `SharedPreferencesAsync` (reads from platform each time). `false` = sync getters via `SharedPreferencesWithCache`. |
| `generateInterface` | `false` | `true` = generates an abstract `${ClassName}Base` class that the concrete class implements. Useful for mocking and DI. |

### Async mode

```dart
@TypedPrefs(async: true)
abstract class _AsyncPreferences {
  static const int pingCount = 0;
}
```

Getters return `Future<int>` instead of `int`. Uses `SharedPreferencesAsync` internally.

### Interface generation (for DI / mocking)

```dart
@TypedPrefs(generateInterface: true)
abstract class _AppPreferences {
  static const int counter = 0;
}
```

Generates `AppPreferencesBase` (abstract) + `AppPreferences implements AppPreferencesBase`. Register the base type in your DI container.

## Field Annotations

### `@PrefKey` — custom storage key

Decouples the Dart field name from the stored key, preventing data loss on field renames:

```dart
@PrefKey('legacy_counter_key')
static const int counter = 0;
```

### `@PrefDateTime` — DateTime encoding

Required on every `DateTime` field. DateTime fields are always nullable.

```dart
@PrefDateTime(DateTimeEncoding.millisecondsSinceEpoch)
static const DateTime? lastSeen = null;  // stored as int (ms since epoch)

@PrefDateTime(DateTimeEncoding.iso8601)
static const DateTime? createdAt = null; // stored as ISO-8601 string
```

`iso8601` getters wrap `DateTime.parse` in a try/catch and return `null` on parse failure.

### Enum types

Any Dart enum is supported without extra annotations. Stored as `enumValue.name` (a string):

```dart
static const ThemeMode theme = ThemeMode.system;
```

## Rules and Constraints

- Class name **must** start with `_` (e.g. `_AppPreferences` generates `AppPreferences`)
- `@TypedPrefs` must annotate a **class** (not a function, mixin, etc.)
- Only `static const` fields are processed; non-const fields are silently ignored
- Field names starting with `_` have the underscore stripped from the preference key
- `DateTime` fields require `@PrefDateTime`; omitting it is a generator error
- Duplicate storage keys (after `@PrefKey` resolution) are a generator error
- Generated files use standalone imports (no `part`/`part of` directives)
- Run `flutter pub run build_runner build` after any schema change

## Testing

For tests, use the constructor directly with an in-memory backend:

```dart
import 'package:shared_preferences/shared_preferences.dart';

setUp(() async {
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.empty();
  await AppPreferences.init();
});

tearDown(() {
  AppPreferences.resetInstance(); // clears _instance and _initFuture
});
```
