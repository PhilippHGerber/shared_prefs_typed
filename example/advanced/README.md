# shared_prefs_typed — Advanced Example (get_it)

This Flutter app demonstrates how to use `shared_prefs_typed` with a dependency
injection framework (`get_it`), showing the recommended pattern for large,
testable applications.

## What it demonstrates

- **Public schema class** — `AppPreferences` (no leading `_`) generates `AppPreferencesImpl`
  and `AppPreferencesImplBase` (the abstract interface)
- **Interface generation** — `@TypedPrefs(generateInterface: true)` produces an abstract
  base that can be registered in `get_it` and mocked in tests
- **Constructor injection** — `AppPreferencesImpl(backend)` accepts the storage backend
  directly; no singleton init required in tests
- **Service locator setup** — `setupLocator()` wires everything together at startup

## Key files

| File | Purpose |
| --- | --- |
| `lib/app_preferences.dart` | Schema — annotated with `@TypedPrefs(generateInterface: true)` |
| `lib/app_preferences.g.dart` | Generated — `AppPreferencesImpl` + `AppPreferencesImplBase` |
| `lib/service_locator.dart` | Registers `AppPreferencesImpl` under `AppPreferencesImplBase` in `get_it` |
| `lib/main.dart` | Calls `setupLocator()` before `runApp`, reads prefs via `getIt<AppPreferencesImplBase>()` |
| `test/app_preferences_test.dart` | Integration tests using constructor injection — no `get_it` setup needed |

## Running

```bash
flutter run
flutter test
```
