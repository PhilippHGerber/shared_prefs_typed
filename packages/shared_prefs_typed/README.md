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

```bash
# Adds the annotations package to your dependencies
flutter pub add shared_prefs_typed_annotations

# Adds the builder and generator to your dev_dependencies
flutter pub add --dev build_runner shared_prefs_typed
```

After running the commands, your pubspec.yaml will be updated. It should look similar to this:

```yaml
dependencies:
  shared_prefs_typed_annotations: ^0.5.2

dev_dependencies:
  build_runner: ^2.4.15
  shared_prefs_typed: ^0.5.2
```

Then, run `flutter pub get`.

## 💡 Usage

### 1. Define Your Preferences

Create a Dart file (e.g., `lib/app_preferences.dart`) and define your preferences using a private abstract class annotated with `@TypedPrefs()`.

```dart
// lib/app_preferences.dart
import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

@TypedPrefs()
abstract class _AppPreferences {
  static const int counter = 0;
  static const String? username = null;
  static const List<String> tagList = ['default'];
}
```

### 2. Run the Code Generator

Execute the following command in your project root to generate the necessary service class:

```bash
flutter pub run build_runner build
```

This will generate the `app_preferences.g.dart` file containing your public `AppPreferences` service class.

### 3. Initialize and Access

The generated class is a singleton that must be initialized asynchronously once, typically in your `main` function. After initialization, you can access your preferences synchronously through the `instance`.

#### Default Mode: Synchronous Access (`@TypedPrefs()`)

This is the recommended mode for most UI-related preferences. Getters are fast and synchronous.

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'app_preferences.g.dart'; // Import the generated file

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the preferences service.
  // It's crucial to wrap this in a try-catch block to handle potential
  // storage access errors on startup.
  try {
    await AppPreferences.init();
  } catch (e) {
    print('Failed to initialize preferences: $e');
  }

  runApp(const MyApp());
}

// In your widgets:
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Access the singleton instance
    final prefs = AppPreferences.instance;

    // 2. Getters are synchronous
    final currentCounter = prefs.counter;

    return FloatingActionButton(
      onPressed: () {
        // 3. Setters are always asynchronous
        prefs.setCounter(currentCounter + 1);
      },
      child: Text('$currentCounter'),
    );
  }
}
```

#### Alternative Mode: Asynchronous Access (`@TypedPrefs(async: true)`)

Use this mode if your preference data can be changed by another isolate or native code, and you need to ensure you're always fetching the latest value from disk.

```dart
// lib/async_prefs.dart
@TypedPrefs(async: true) // Enable async mode
abstract class _AsyncPrefs {
  static const int pingCount = 0;
}

// --- Usage ---
// final prefs = AsyncPrefs.instance;

// Getters now return a Future and must be awaited.
final count = await prefs.pingCount;

// Setters remain asynchronous.
await prefs.setPingCount(count + 1);
```

### ✅ Testing

The generated code is designed to be easily testable. By replacing the `shared_preferences` platform implementation with an in-memory mock, you can run tests quickly and reliably without accessing device storage.

Here is a complete test example:

```dart
// test/app_preferences_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:test_app/app_preferences.g.dart';

void main() {
  setUpAll(() {
    // Ensure the test framework is initialized.
    TestWidgetsFlutterBinding.ensureInitialized();

    // CRITICAL: Replace the platform-specific implementation with a mock
    // in-memory version for all tests in this file.
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });

  // A helper to initialize the service for each test.
  Future<AppPreferences> initPrefs() async {
    await AppPreferences.init();
    return AppPreferences.instance;
  }

  test('Counter returns default value and can be set', () async {
    // ARRANGE: Clear previous values and initialize.
    await SharedPreferencesAsyncPlatform.instance?.clear();
    final prefs = await initPrefs();

    // ASSERT: Check default value.
    expect(prefs.counter, 0);

    // ACT: Set a new value.
    await prefs.setCounter(42);

    // ASSERT: Verify the new value.
    expect(prefs.counter, 42);
  });
}
```

For more detailed examples, please see the `example/` directory in the project repository.

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
