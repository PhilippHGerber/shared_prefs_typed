import 'package:meta/meta_meta.dart';

import 'date_time_encoding.dart';

/// Required on every [DateTime] field in a `@TypedPrefs` class.
///
/// Specifies how the DateTime value is serialized for storage.
///
/// ```dart
/// @TypedPrefs()
/// abstract class _AppPrefs {
///   @PrefDateTime(DateTimeEncoding.millisecondsSinceEpoch)
///   static const DateTime? lastLogin = null;
///
///   // Non-nullable getter: returns epoch when key is absent.
///   @PrefDateTime(DateTimeEncoding.millisecondsSinceEpoch, defaultMillis: 0)
///   static const DateTime? installDate = null;
/// }
/// ```
@Target({TargetKind.field})
class PrefDateTime {
  /// Creates a [PrefDateTime] annotation with the given [encoding] strategy.
  ///
  /// Pass [defaultMillis] (milliseconds since epoch) to produce a non-nullable
  /// getter. When the key is absent the getter returns
  /// `DateTime.fromMillisecondsSinceEpoch(defaultMillis)` instead of `null`.
  const PrefDateTime(this.encoding, {this.defaultMillis});

  /// The encoding strategy for the DateTime value.
  final DateTimeEncoding encoding;

  /// Optional default value expressed as milliseconds since epoch.
  ///
  /// When non-null, the generated getter returns a non-nullable `DateTime`
  /// with this value as the fallback when the key is absent.
  final int? defaultMillis;
}
