// ignore_for_file: unused_element, unused_field // This file is used for code generation and may contain unused elements or fields.

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'enum_list_case.g.dart';

enum ThemeMode { light, dark, system }

enum Priority { low, medium, high }

@TypedPrefs()
abstract class _EnumListPrefs {
  static const List<ThemeMode> themes = [ThemeMode.light, ThemeMode.dark];
  static const List<Priority> priorities = [Priority.medium];
  static const List<ThemeMode>? optionalThemes = null;
}
