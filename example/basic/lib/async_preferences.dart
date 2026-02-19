import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

/// Defines the data contract for preferences accessed asynchronously.
/// The key difference: *enabling async mode* via `@TypedPrefs(async: true)`.
@TypedPrefs(async: true)
abstract class AsyncPreferences {
  /// A non-nullable async counter.
  static const int pingCount = 0;

  /// A nullable async string value.
  static const String? serverId = null;

  /// An async boolean flag.
  static const bool isCacheEnabled = true;
}
