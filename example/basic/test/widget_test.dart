// Import the generated preferences service and the main app widget.
import 'package:basic_example/theme_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// IMPORTANT: These three imports are required for mocking the shared_preferences backend.
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

void main() {
  /// This block runs once before any tests in this file.
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });

  setUp(() async {
    final store = SharedPreferencesAsyncPlatform.instance;
    await store?.clear(
      const ClearPreferencesParameters(filter: PreferencesFilters()),
      const SharedPreferencesOptions(),
    );
    SettingsPrefsImpl.resetInstance();
    await SettingsPrefsImpl.init();
  });

  testWidgets('Theme selection should be persisted correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Initial state is ThemeMode.system.
    expect(SettingsPrefsImpl.instance.themeMode, ThemeMode.system);

    // Tap the "Dark" segment.
    await tester.tap(find.byIcon(Icons.nightlight_round));
    await tester.pumpAndSettle();

    expect(SettingsPrefsImpl.instance.themeMode, ThemeMode.dark);

    final segmentedButton = tester.widget<SegmentedButton<ThemeMode>>(
      find.byType(SegmentedButton<ThemeMode>),
    );
    expect(segmentedButton.selected.first, ThemeMode.dark);
  });

  testWidgets('Initial theme should be loaded from preferences', (WidgetTester tester) async {
    // Pre-set a value before building the app.
    await SettingsPrefsImpl.instance.setThemeMode(ThemeMode.light);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final segmentedButton = tester.widget<SegmentedButton<ThemeMode>>(
      find.byType(SegmentedButton<ThemeMode>),
    );
    expect(segmentedButton.selected.first, ThemeMode.light);
  });
}
