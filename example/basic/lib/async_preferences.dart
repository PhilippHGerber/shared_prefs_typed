import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

part 'async_preferences.g.dart';

/// Defines the data contract for preferences accessed asynchronously.
/// The key difference: *enabling async mode* via `@TypedPrefs(mode: PrefsMode.async)`.
@TypedPrefs(mode: PrefsMode.async)
abstract class AsyncPreferences {
  /// A non-nullable async counter.
  static const int pingCount = 0;

  /// A nullable async string value.
  static const String? serverId = null;

  /// An async boolean flag.
  static const bool isCacheEnabled = true;
}
