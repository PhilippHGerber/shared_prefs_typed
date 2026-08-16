// ignore_for_file: unused_element, unused_field // This file is used for code generation and may contain unused elements or fields.

import 'dart:developer';

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'date_time_iso_case.g.dart';

@TypedPrefs()
abstract class _DateTimeIsoPrefs {
  @PrefDateTime(DateTimeEncoding.iso8601)
  static const DateTime? lastLogin = null;
  @PrefDateTime(DateTimeEncoding.iso8601)
  static const DateTime? updatedAt = null;
}
