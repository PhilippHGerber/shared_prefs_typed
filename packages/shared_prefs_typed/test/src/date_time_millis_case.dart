// ignore_for_file: unused_element, unused_field // This file is used for code generation and may contain unused elements or fields.

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'date_time_millis_case.g.dart';

@TypedPrefs()
abstract class _DateTimeMillisPrefs {
  @PrefDateTime(DateTimeEncoding.millisecondsSinceEpoch)
  static const DateTime? lastLogin = null;
  @PrefDateTime(DateTimeEncoding.millisecondsSinceEpoch)
  static const DateTime? createdAt = null;
}
