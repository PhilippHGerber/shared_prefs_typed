// This file is used as test input for code generation.
// ignore_for_file: unused_element, unused_field

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

// Tests that async: true and generateInterface: true can be combined, which
// exercises the async branch of the interface getter return type (Future<T>).
@TypedPrefs(async: true, generateInterface: true)
abstract class _AsyncInterfacePrefs {
  static const String message = 'hello';
  static const int count = 0;
}
