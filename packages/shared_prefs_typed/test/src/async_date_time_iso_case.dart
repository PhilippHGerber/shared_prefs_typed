// This file is used as test input for code generation.
// ignore_for_file: unused_element, unused_field

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'async_date_time_iso_case.g.dart';

@TypedPrefs(mode: PrefsMode.async)
abstract class _AsyncDateTimeIsoPrefs {
  @PrefDateTime(DateTimeEncoding.iso8601)
  static const DateTime? lastLogin = null;
  @PrefDateTime(DateTimeEncoding.iso8601)
  static const DateTime? updatedAt = null;
}
