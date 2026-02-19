# shared_prefs_typed - Agent Guide

Type-safe SharedPreferences for Flutter via `build_runner` code generation.

## What It Does

Annotate a **private abstract class** with `@TypedPrefs()` and declare `static const` fields. The generator produces a public class with a shared-instance accessor and typed getters, setters, `contains` checks, and `remove` methods for each field.

## Setup

Add to `pubspec.yaml`:

```sh
# Adds the annotations package to your dependencies
flutter pub add shared_prefs_typed_annotations

# Adds the builder and generator to your dev_dependencies
flutter pub add --dev build_runner shared_prefs_typed
```

Run code generation:

```sh
flutter pub run build_runner build
```

## Supported Types

`int`, `double`, `bool`, `String`, `List<String>`, `List<int>`, `List<double>` — plus nullable variants (`int?`, `double?`, `bool?`, `String?`).

Also supported: **Enum types** (any Dart enum) and **`DateTime`** (requires `@PrefDateTime` annotation; nullable by default, non-nullable when `defaultMillis:` is provided).

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
  static const DateTime? lastLogin = null; // nullable getter (DateTime?)
  @PrefDateTime(DateTimeEncoding.millisecondsSinceEpoch, defaultMillis: 0)
  static const DateTime? installDate = null; // non-nullable getter (DateTime)
  @PrefKey('legacy_theme_key')
  static const ThemeMode theme = ThemeMode.system; // Enum with custom key
}
```

### 2. Generated output (`app_preferences.g.dart`)

The generator creates class `AppPreferences` (leading `_` stripped) with:

- **Constructor**: `AppPreferences(SharedPreferencesWithCache prefs)` — for DI/testing
- **Singleton**: `static Future<AppPreferences> init()` (concurrency-safe, idempotent) + `static AppPreferences get instance` (throws `StateError` if `init` not called)
- **Teardown**: `@visibleForTesting static void resetInstance()` — clears both `_instance` and `_initFuture`; use in test teardown only
- **Error hook**: `static void Function(String key, Object error)? onReadError` — optional callback invoked when a stored value cannot be cast to its expected type; defaults to `null`
- **Per field** (e.g. `counter`):
  - `int get counter` — sync getter, returns default if unset; catch block calls `dart:developer log()` and `onReadError` on type mismatch
  - `Future<void> setCounter(int value)` — async setter
  - `bool containsCounter()` — checks if key exists
  - `Future<void> removeCounter()` — removes key
- **`clearAll()`**: `Future<void> clearAll()` — removes all keys owned by this class via `Future.wait`; also generated on the interface when `generateInterface: true`

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
  print(prefs.containsCounter());     // true
  await prefs.removeCounter();
  print(prefs.counter);            // 0 (back to default)
}
```

## Annotation Options

| Option | Default | Effect |
|---|---|---|
| `mode` | `null` | `PrefsMode.async` = async getters via `SharedPreferencesAsync`. `PrefsMode.cached` or omitted = sync getters via `SharedPreferencesWithCache`. |
| `generateInterface` | `false` | `true` = generates an abstract `${ClassName}Base` class that the concrete class implements. Useful for mocking and DI. |

### Async mode

```dart
@TypedPrefs(mode: PrefsMode.async)
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

Required on every `DateTime` field. Fields must be declared `DateTime?` (no const DateTime constructors exist in Dart).

```dart
@PrefDateTime(DateTimeEncoding.millisecondsSinceEpoch)
static const DateTime? lastSeen = null;  // stored as int; getter returns DateTime?

@PrefDateTime(DateTimeEncoding.iso8601)
static const DateTime? createdAt = null; // stored as ISO-8601 string; getter returns DateTime?

// Non-nullable getter: pass defaultMillis to get DateTime instead of DateTime?
@PrefDateTime(DateTimeEncoding.millisecondsSinceEpoch, defaultMillis: 0)
static const DateTime? installDate = null; // getter returns DateTime (epoch fallback)
```

`iso8601` getters wrap `DateTime.parse` in a try/catch and return the default on parse failure.

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
- Reserved field names (generator error): `init`, `instance`, `resetInstance`, `clearAll`, `onReadError`
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

To test the type-migration guard (or the `onReadError` callback), write a wrong-type value to the platform store *before* calling `init()` so the cache loads it:

```dart
test('int field returns default on type mismatch', () async {
  await SharedPreferencesAsyncPlatform.instance!
      .setString('counter', 'bad', const SharedPreferencesOptions());
  await AppPreferences.init();
  expect(AppPreferences.instance.counter, 0); // default, not a crash
});
```

Note: `onReadError` is NOT reset by `resetInstance()`; set it to `null` explicitly in `tearDown` when testing it.
