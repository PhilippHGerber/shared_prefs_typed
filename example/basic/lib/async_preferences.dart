// ignore_for_file: unused_element, unused_field // This file is used for code generation and may contain unused elements or fields.

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

/// Defines the data contract for preferences that will be accessed asynchronously.
/// The key difference: *enabling async mode*
@TypedPrefs(async: true)
abstract class _AsyncPreferences {
  /// A non-nullable async counter.
  static const int pingCount = 0;

  /// A nullable async string value.
  static const String? serverId = null;

  /// An async boolean flag.
  static const bool isCacheEnabled = true;
}
