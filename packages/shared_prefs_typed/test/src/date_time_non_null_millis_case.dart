// This file is used as test input for code generation.
// ignore_for_file: unused_element, unused_field

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'date_time_non_null_millis_case.g.dart';

// Tests that @PrefDateTime(defaultMillis:) produces a non-nullable getter.
@TypedPrefs()
abstract class _DateTimeNonNullMillisPrefs {
  @PrefDateTime(DateTimeEncoding.millisecondsSinceEpoch, defaultMillis: 0)
  static const DateTime? installDate = null;
}
