import 'package:meta/meta_meta.dart';

import 'src/prefs_mode.dart';

export 'package:meta/meta.dart';

export 'src/pref_date_time.dart';
export 'src/pref_key.dart';
export 'src/prefs_mode.dart';

/// Annotates a private abstract class to generate a type-safe singleton
/// service for the modern `shared_preferences` plugin APIs.
///
/// The annotated class name **must** start with an underscore (`_`).
/// The generator creates methods for accessing preferences based on the
/// `static const` fields defined in the annotated class.
@Target({TargetKind.classType})
class TypedPrefs {
  /// Const constructor to allow the annotation to be const.
  const TypedPrefs({
    this.mode,
    this.generateInterface = false,
  });

  /// The access mode for the generated class.
  ///
  /// Use [PrefsMode.cached] (default) for `SharedPreferencesWithCache` and
  /// synchronous getters, or [PrefsMode.async] for `SharedPreferencesAsync`
  /// and asynchronous getters.
  final PrefsMode? mode;

  /// If `true`, generates an abstract `${ClassName}Base` interface alongside
  /// the concrete class. The concrete class implements this interface, enabling
  /// clean mocking with Mockito/Mocktail and typed DI registrations.
  ///
  /// Defaults to `false` to keep the simple case simple.
  final bool generateInterface;
}
