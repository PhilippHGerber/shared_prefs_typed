# shared_prefs_typed Example Application

This Flutter application serves as a comprehensive demonstration and testing ground for the `shared_prefs_typed` package. It showcases how to define, generate, and use type-safe preferences in a real application.

## 🌟 Key Examples Inside

This project contains several key examples in the `lib/` directory:

* **`main.dart`**: A complete example of a stateful counter and an editable user greeting, demonstrating the default synchronous getter (`@TypedPrefs()`).
* **`theme_example.dart`**: Shows how to manage and persist app-wide state, like the theme (Light/Dark/System), using nullable preferences.
* **`app_preferences.dart`**: The schema definition for the preferences used in the main examples.
* **`async_prefs.dart`**: A schema definition that explicitly uses `@TypedPrefs(mode: PrefsMode.async)` to demonstrate the asynchronous getter mode.

## ✅ How Testing Works

A critical feature of this package is its testability. The tests in this example project do **not** write to actual device storage. Instead, they use an in-memory mock provided by the official `shared_preferences` plugin, making them fast, reliable, and platform-independent.

### The Testing Strategy

The magic happens in the `setUpAll` block of our test files (e.g., `test/app_preferences_test.dart`):

```dart
import 'package:flutter_test/flutter_test.dart';
// These imports are the key to our testing strategy
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUpAll(() {
    // Before any tests run, we replace the real, platform-specific
    // implementation of SharedPreferences with a mock, in-memory version.
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });

  // ... your tests go here
}
```

### Why This is Powerful

1. **No "Real" Data:** All calls to `AppPreferencesImpl.init()` and subsequent preference operations (`get`, `set`, `remove`) are automatically routed to our in-memory mock instead of the device's file system.
2. **Clean State for Every Test:** In a `setUp` block before each test, we can instantly clear the mock store, ensuring that every test runs in a clean, predictable environment without any state leaking from previous tests.

    ```dart
    setUp(() async {
      // Clear the in-memory store to ensure a clean slate
      await SharedPreferencesAsyncPlatform.instance?.clear();

      // Now, initialize our service. It will use the clean, empty mock store.
      await AppPreferencesImpl.init();
    });
    ```

3. **Speed and Reliability:** Since there is no disk I/O, the tests run extremely fast. They are also 100% reliable and can be executed on any machine without needing a physical device or emulator.

This approach allows you to test your application's logic that depends on `shared_preferences` with confidence. You can see this pattern applied in:

* **`test/app_preferences_test.dart`**: Unit tests for the synchronous `AppPreferences` service.
* **`test/async_prefs_test.dart`**: Unit tests for the asynchronous `AsyncPrefs` service.
* **`test/widget_test.dart`**: A widget test demonstrating how to test a UI that interacts with the preferences service.

### How to Run

* **To run the application:**

    ```bash
    flutter run
    ```

* **To run all tests:**

    ```bash
    flutter test
    ```
