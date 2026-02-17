// Import the generated preferences service and the main app widget.
import 'package:basic_example/theme_example.dart';
import 'package:basic_example/theme_example.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// IMPORTANT: These three imports are required for mocking the shared_preferences backend.
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

void main() {
  /// This block runs once before any tests in this file.
  setUpAll(() {
    // Ensure the Flutter test framework is initialized.
    TestWidgetsFlutterBinding.ensureInitialized();

    // THIS IS THE CRITICAL STEP FOR TESTING:
    //    We replace the platform-specific implementation of shared_preferences
    //    (which would write to disk) with a fast, reliable in-memory version.
    //    All subsequent calls to your generated `SettingsPrefs` class will now
    //    use this in-memory store automatically.
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });

  /// This block runs before each individual test.
  setUp(() async {
    // Clear the in-memory store to ensure that each test starts from a
    // clean and predictable state. This prevents state leakage between tests.
    final store = SharedPreferencesAsyncPlatform.instance;
    await store?.clear(
      const ClearPreferencesParameters(filter: PreferencesFilters()),
      const SharedPreferencesOptions(),
    );

    // Initialize your generated preferences service, just like in the real app.
    // It will now operate on the in-memory store.
    await SettingsPrefs.init();
  });

  testWidgets('Theme selection should be persisted correctly', (WidgetTester tester) async {
    // ARRANGE: Build the application.
    await tester.pumpWidget(const MyApp());

    // Ensure the initial state is 'System' (null).
    expect(SettingsPrefs.instance.isLight, isNull);

    // ACT: Find the "Dark" theme button by its icon and tap it.
    await tester.tap(find.byIcon(Icons.nightlight_round));

    // Wait for the state change and UI to rebuild.
    await tester.pumpAndSettle();

    // ASSERT: Verify that the value was correctly saved to our in-memory store.
    // We query the generated instance directly.
    expect(SettingsPrefs.instance.isLight, isFalse);

    // Optional: Verify that the UI has updated to reflect the new state.
    final segmentedButton = tester.widget<SegmentedButton<bool?>>(
      find.byType(SegmentedButton<bool?>),
    );
    expect(segmentedButton.selected.first, isFalse);
  });

  testWidgets('Initial theme should be loaded from preferences', (WidgetTester tester) async {
    // ARRANGE: Set an initial value in the in-memory store *before* building the app.
    await SettingsPrefs.instance.setIsLight(true); // Start with Light theme.

    // ACT: Build the app. The `initState` in MyApp should now read this value.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // ASSERT: Verify that the UI correctly displays the pre-loaded state.
    final segmentedButton = tester.widget<SegmentedButton<bool?>>(
      find.byType(SegmentedButton<bool?>),
    );
    expect(segmentedButton.selected.first, isTrue);
  });
}
