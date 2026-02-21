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
