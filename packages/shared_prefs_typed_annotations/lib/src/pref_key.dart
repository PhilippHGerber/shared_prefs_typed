import 'package:meta/meta_meta.dart';

/// Overrides the SharedPreferences persistence key for a field.
///
/// Use this to decouple the Dart field name from the stored key, so
/// renaming a field does not cause data loss on app updates.
///
/// ```dart
/// @TypedPrefs()
/// abstract class _AppPrefs {
///   @PrefKey('legacy_counter_key')
///   static const int counter = 0;
/// }
/// ```
@Target({TargetKind.field})
class PrefKey {
  /// Creates a [PrefKey] annotation with the given persistence [key].
  const PrefKey(this.key);

  /// The key used to store and retrieve this preference in SharedPreferences.
  final String key;
}
