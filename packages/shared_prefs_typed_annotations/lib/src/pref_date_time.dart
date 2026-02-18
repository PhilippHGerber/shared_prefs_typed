import 'package:meta/meta_meta.dart';

/// Specifies how a [DateTime] field is encoded in SharedPreferences.
enum DateTimeEncoding {
  /// Store as milliseconds since epoch (an `int`).
  ///
  /// Fast integer comparison, compact storage.
  /// Loses sub-millisecond precision and timezone info.
  millisecondsSinceEpoch,

  /// Store as ISO-8601 string (e.g. `'2024-01-15T10:30:00.000Z'`).
  ///
  /// Human-readable in debug tools, preserves timezone info.
  iso8601,
}

/// Required on every [DateTime] field in a `@TypedPrefs` class.
///
/// Specifies how the DateTime value is serialized for storage.
///
/// ```dart
/// @TypedPrefs()
/// abstract class _AppPrefs {
///   @PrefDateTime(DateTimeEncoding.millisecondsSinceEpoch)
///   static const DateTime? lastLogin = null;
/// }
/// ```
@Target({TargetKind.field})
class PrefDateTime {
  /// Creates a [PrefDateTime] annotation with the given [encoding] strategy.
  const PrefDateTime(this.encoding);

  /// The encoding strategy for the DateTime value.
  final DateTimeEncoding encoding;
}
