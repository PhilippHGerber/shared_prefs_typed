// This file is used as test input for code generation.
// ignore_for_file: unused_element, unused_field

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'string_escaping_case.g.dart';

// Tests that special characters in string default values are correctly escaped
// in generated code: backslashes, dollar signs, newlines, tabs, and single quotes.
@TypedPrefs()
abstract class _StringEscapingPrefs {
  static const String withBackslash = r'path\to\file';
  static const String withDollarSign = r'cost is $10';
  static const String withNewline = 'line1\nline2';
  static const String withTab = 'col1\tcol2';
  static const String withSingleQuote = "it's here";
  static const String withInterpolation = r"Hello ${world} with 'quotes'";
}
