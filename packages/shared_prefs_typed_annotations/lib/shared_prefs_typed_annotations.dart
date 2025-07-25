/// Annotates a class to generate a mixin with type-safe helpers for
/// the modern `shared_preferences` plugin APIs.
///
/// The generator creates methods for accessing preferences based on the
/// `static const` fields defined in the annotated class.
class TypedPrefs {
  /// Const constructor to allow the annotation to be const.
  const TypedPrefs({this.async = false});

  /// If `false` (default), the generator uses SharedPreferencesWithCache.
  /// This provides **synchronous getters** for fast, cached access, which is
  /// ideal for performance-critical UI updates.
  ///
  /// If `true`, the generator uses SharedPreferencesAsync.
  /// This provides **asynchronous getters**, where every read operation fetches
  /// the latest value from the platform's persistent storage. This is useful
  /// when data might be changed by other isolates or native code.
  final bool async;
}
