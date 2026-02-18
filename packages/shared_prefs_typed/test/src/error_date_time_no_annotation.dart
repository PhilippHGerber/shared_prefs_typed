// This file is used as test input for error case validation.
// ignore_for_file: unused_element, unused_field

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

@TypedPrefs()
abstract class _BadDateTimePrefs {
  static const DateTime? createdAt = null;
}
