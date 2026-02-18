import 'package:meta/meta_meta.dart';

export 'src/pref_date_time.dart';
export 'src/pref_key.dart';

/// Annotates a private abstract class to generate a type-safe singleton
/// service for the modern `shared_preferences` plugin APIs.
///
/// The annotated class name **must** start with an underscore (`_`).
/// The generator creates methods for accessing preferences based on the
/// `static const` fields defined in the annotated class.
@Target({TargetKind.classType})
class TypedPrefs {
  /// Const constructor to allow the annotation to be const.
  const TypedPrefs({this.async = false, this.generateInterface = false});

  /// If `false` (default), the generator uses SharedPreferencesWithCache.
  /// This provides **synchronous getters** for fast, cached access, which is
  /// ideal for performance-critical UI updates.
  ///
  /// If `true`, the generator uses SharedPreferencesAsync.
  /// This provides **asynchronous getters**, where every read operation fetches
  /// the latest value from the platform's persistent storage. This is useful
  /// when data might be changed by other isolates or native code.
  final bool async;

  /// If `true`, generates an abstract `${ClassName}Base` interface alongside
  /// the concrete class. The concrete class implements this interface, enabling
  /// clean mocking with Mockito/Mocktail and typed DI registrations.
  ///
  /// Defaults to `false` to keep the simple case simple.
  final bool generateInterface;
}
