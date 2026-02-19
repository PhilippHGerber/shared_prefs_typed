import 'package:meta/meta_meta.dart';

import 'src/prefs_mode.dart';

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
    @Deprecated(
      'Use mode: PrefsMode.async instead. '
      'The async parameter will be removed in 1.0.0.',
    )
    this.async = false,
    this.mode,
    this.generateInterface = false,
  });

  /// If `true`, the generator uses `SharedPreferencesAsync` instead of
  /// `SharedPreferencesWithCache`.
  ///
  /// Prefer [mode] over this parameter. Will be removed in 1.0.0.
  @Deprecated(
    'Use mode: PrefsMode.async instead. '
    'The async parameter will be removed in 1.0.0.',
  )
  final bool async;

  /// The access mode for the generated class.
  ///
  /// Use [PrefsMode.cached] (default) for `SharedPreferencesWithCache` and
  /// synchronous getters, or [PrefsMode.async] for `SharedPreferencesAsync`
  /// and asynchronous getters.
  ///
  /// When `null`, the deprecated `async` field is used for backwards
  /// compatibility.
  final PrefsMode? mode;

  /// If `true`, generates an abstract `${ClassName}Base` interface alongside
  /// the concrete class. The concrete class implements this interface, enabling
  /// clean mocking with Mockito/Mocktail and typed DI registrations.
  ///
  /// Defaults to `false` to keep the simple case simple.
  final bool generateInterface;
}
