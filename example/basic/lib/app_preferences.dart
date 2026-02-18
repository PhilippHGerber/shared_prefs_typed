// ignore_for_file: unused_element // This file is used for code generation and may contain unused elements.
// ignore_for_file: unused_field // This file is used for code generation and may contain unused fields.

import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

/// Defines the data contract for the application's preferences.
///
/// This private, abstract class serves as a schema for the code generator.
/// The generator reads the `static const` fields defined here and creates a
/// public singleton class `AppPreferences` with type-safe getters and setters.
///
/// Best Practice: Keep this definition in its own file to cleanly separate
/// the data layer from the UI layer.
@TypedPrefs()
abstract class _AppPreferences {
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
  // The getter will return `100` if the key is not set, but you can still
  // set the value to `null` to explicitly clear it.

  /// A counter that can be cleared, reverting to its default of 100.
  // ignore: unnecessary_nullable_for_final_variable_declarations for test purposes
  static const int? nullableCounterWithDefault = 100;
}
