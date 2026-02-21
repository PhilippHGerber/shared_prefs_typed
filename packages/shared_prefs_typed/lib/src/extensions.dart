import 'package:analyzer/dart/element/element.dart';

/// String utilities for identifier case conversion.
extension StringX on String {
  /// Converts the first character to uppercase: `'fooBar'` → `'FooBar'`.
  String toPascalCase() => isEmpty ? '' : this[0].toUpperCase() + substring(1);

  /// Converts the first character to lowercase: `'FooBar'` → `'fooBar'`.
  String toCamelCase() => isEmpty ? '' : this[0].toLowerCase() + substring(1);
}

/// Name helpers for generating class names from annotated source classes.
extension ClassElementX on ClassElement {
  /// Returns the public name for the generated class.
  /// - If the annotated class starts with `_` (private), strips it: `_AppPrefs` → `AppPrefs`.
  /// - Otherwise appends `Impl`: `AppPrefs` → `AppPrefsImpl`.
  String get generatedClassName {
    final n = name!;
    return n.startsWith('_') ? n.substring(1) : '${n}Impl';
  }

  /// Returns the interface name for the generated class.
  /// Always uses the original class name (without `_` or `Impl`) + `Base`.
  /// - `_AppPrefs` → `AppPrefsBase`
  /// - `AppPrefs`  → `AppPrefsBase`
  String get generatedInterfaceName {
    final n = name!;
    return '${n.startsWith('_') ? n.substring(1) : n}Base';
  }
}
