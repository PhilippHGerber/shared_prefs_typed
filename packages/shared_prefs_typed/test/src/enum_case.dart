// ignore_for_file: unused_element, unused_field // This file is used for code generation and may contain unused elements or fields.

import 'dart:developer';

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'enum_case.g.dart';

enum ThemeMode { light, dark, system }

enum FontSize { small, medium, large }

@TypedPrefs()
abstract class _EnumPrefs {
  static const ThemeMode theme = ThemeMode.dark;
  static const ThemeMode? optionalTheme = null;
  static const FontSize fontSize = FontSize.medium;
}
