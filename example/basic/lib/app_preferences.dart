import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

part 'app_preferences.g.dart';

/// Defines the data contract for the application's preferences.
///
/// This abstract class serves as a schema for the code generator.
/// The generator reads the `static const` fields defined here and creates
/// `AppPreferencesImpl` (in `app_preferences.g.dart`) with type-safe
/// getters and setters.
///
/// Best Practice: Keep this definition in its own file to cleanly separate
/// the data layer from the UI layer.
@TypedPrefs()
abstract class AppPreferences {
  /// The current count for the counter feature.
  /// Defaults to 0 if no value is stored.
  static const int counter = 0;

  /// The display name of the user for personalized greetings.
  /// Defaults to 'World' if no name is stored.
  static const String? displayGreeting = null;

  /// A sample double value.
  static const double pi = 3.14;

  /// A flag to check if the user has completed the welcome flow.
  static const bool isWelcomeScreenDone = false;

  /// A personalized greeting message.
  static const String greeting = 'Hello';

  /// A list of user-defined tags.
  static const List<String> tagList = <String>['default'];

  /// Recently viewed item IDs, stored newest-first.
  ///
  /// Serialized transparently as `List<String>` in storage; parsed back to
  /// `List<int>` on read. Defaults to an empty list.
  static const List<int> recentItemIds = <int>[];

  /// Historical price samples for display in a chart.
  ///
  /// Serialized as `List<String>` in storage; parsed back to `List<double>`
  /// on read. Defaults to a sample set of three prices.
  static const List<double> priceHistory = <double>[9.99, 14.99, 19.99];

  // --- Nullable types ---
  // Useful for values that don't have a logical default and may not exist.

  /// The session ID, which is null until the user logs in.
  static const String? sessionId = null;

  /// The timestamp of the last login, null if never logged in.
  static const int? lastLoginTimestamp = null;

  // --- Edge Case: Nullable type with a non-null default ---
  // The getter returns `int` (non-nullable) because the default is 100.
  // The setter accepts `int?` — pass `null` to reset to the default.

  /// A counter that can be cleared, reverting to its default of 100.
  // ignore: unnecessary_nullable_for_final_variable_declarations
  static const int? nullableCounterWithDefault = 100;

  // --- DateTime fields (nullable) ---

  /// The date of the last background sync, stored as ISO 8601.
  @PrefDateTime(DateTimeEncoding.iso8601)
  static const DateTime? lastSyncDate = null;

  /// The timestamp of the last login in milliseconds since epoch.
  @PrefDateTime(DateTimeEncoding.millisecondsSinceEpoch)
  static const DateTime? lastLoginDate = null;
}
