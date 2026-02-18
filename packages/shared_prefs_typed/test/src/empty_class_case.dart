// This file is used as test input for code generation.
// ignore_for_file: unused_element

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

// Tests that a class with zero fields still generates a valid singleton class
// with init(), instance getter, and resetInstance(), but no field-specific methods.
@TypedPrefs()
abstract class _EmptyPrefs {}
