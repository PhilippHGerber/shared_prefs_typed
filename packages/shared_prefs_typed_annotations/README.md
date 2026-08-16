# shared_prefs_typed_annotations

This package provides the annotations used by the `shared_prefs_typed` code generator.

Its sole purpose is to provide the `@TypedPrefs` annotation, which marks a class for code generation.

## Usage

You only need to use this package to annotate your preference schema. The main logic, installation, and usage patterns are found in the primary `shared_prefs_typed` package.

**Example of a preference schema:**

```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

part 'app_preferences.g.dart';

@TypedPrefs()
abstract class AppPreferences {
  static const int counter = 0;
  static const String? username = null;
}
```

---

For complete installation instructions, usage guides, and advanced features, please see the documentation for the main **[shared_prefs_typed](https://pub.dev/packages/shared_prefs_typed)** package.
