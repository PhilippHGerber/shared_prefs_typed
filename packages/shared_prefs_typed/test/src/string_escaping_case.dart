// This file is used as test input for code generation.
// ignore_for_file: unused_element, unused_field

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

// Tests that special characters in string default values are correctly escaped
// in generated code: backslashes, dollar signs, newlines, tabs, and single quotes.
@TypedPrefs()
abstract class _StringEscapingPrefs {
  static const String withBackslash = r'path\to\file';
  static const String withDollarSign = r'cost is $10';
  static const String withNewline = 'line1\nline2';
  static const String withTab = 'col1\tcol2';
  static const String withSingleQuote = "it's here";
}
