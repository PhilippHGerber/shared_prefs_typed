import 'package:flutter/material.dart';
import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

import 'theme_example.g.dart';

/// Defines the data contract for the application's settings preferences.
@TypedPrefs()
abstract class SettingsPrefs {
  /// This preference is stored as a nullable boolean with the following mapping:
  /// - `true`:  ThemeMode.light
  /// - `false`: ThemeMode.dark
  /// - `null`:  ThemeMode.system (this is the default value)
  static const bool? isLight = null;
}

/// The main entry point for the application.
Future<void> main() async {
  // Required to ensure that plugin services are initialized before `runApp`.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize our preferences service. This must be done once on startup.
  // After this `await`, `SettingsPrefsImpl.instance` is available for use.
  await SettingsPrefsImpl.init();

  runApp(const MyApp());
}

// --- Root Widget and State Management ---

/// The root widget of the application.
///
/// This is a [StatefulWidget] because it holds and manages the application's
/// current [ThemeMode]. When the user changes the theme, this widget rebuilds
/// the [MaterialApp] with the new theme setting.
class MyApp extends StatefulWidget {
  /// Creates the root application widget.
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // The state variable that holds the current theme for the UI.
  // It is initialized in `initState` to avoid using `late`.
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    // On startup, read the saved preference and set the initial theme.
    // We can safely access the singleton instance because `init()` was called in `main`.
    final isLight = SettingsPrefsImpl.instance.isLight;
    _themeMode = _getThemeModeFromPreference(isLight);
  }

  /// Converts the stored preference (`bool?`) into a Flutter [ThemeMode].
  ThemeMode _getThemeModeFromPreference(bool? isLight) {
    switch (isLight) {
      case true:
        return ThemeMode.light;
      case false:
        return ThemeMode.dark;
      case null:
        return ThemeMode.system;
    }
  }

  /// Updates the theme, persists the choice, and rebuilds the UI.
  ///
  /// This method is passed as a callback to child widgets, allowing them
  /// to trigger a state change in this root widget.
  Future<void> _changeTheme(bool? newIsLightPreference) async {
    // 1. Persist the new choice to SharedPreferences using the generated setter.
    await SettingsPrefsImpl.instance.setIsLight(newIsLightPreference);

    // 2. Update the local state to trigger a UI rebuild with the new theme.
    setState(() {
      _themeMode = _getThemeModeFromPreference(newIsLightPreference);
    });
  }

  @override
  Widget build(BuildContext context) {
    // We get the current preference value here to pass it down to the UI.
    final currentPreference = SettingsPrefsImpl.instance.isLight;

    return MaterialApp(
      title: 'Simple Theme Demo',
      // Define both a light and a dark theme for the app.
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // Use the state variable to control which theme is currently active.
      themeMode: _themeMode,
      home: MyHomePage(
        // Pass the current state and the change handler down to the UI.
        currentPreference: currentPreference,
        onThemeChanged: _changeTheme,
      ),
    );
  }
}

// --- UI Screen Widget ---

/// The home page of the application, responsible for displaying the UI.
///
/// This is a [StatelessWidget] because it does not manage its own state.
/// It receives its data (`currentPreference`) and behavior (`onThemeChanged`)
/// from its parent widget.
class MyHomePage extends StatelessWidget {
  /// Creates the home page widget.
  const MyHomePage({
    required this.currentPreference,
    required this.onThemeChanged,
    super.key,
  });

  /// The currently selected theme preference (`true`, `false`, or `null`).
  final bool? currentPreference;

  /// A callback function to notify the parent widget of a theme change.
  final ValueChanged<bool?> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Selector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Choose your theme:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            SegmentedButton<bool?>(
              segments: const [
                ButtonSegment(
                  value: null,
                  label: Text('System'),
                  icon: Icon(Icons.brightness_auto),
                ),
                ButtonSegment(
                  value: true,
                  label: Text('Light'),
                  icon: Icon(Icons.wb_sunny),
                ),
                ButtonSegment(
                  value: false,
                  label: Text('Dark'),
                  icon: Icon(Icons.nightlight_round),
                ),
              ],
              selected: {currentPreference},
              onSelectionChanged: (newSelection) {
                onThemeChanged(newSelection.first);
              },
            ),
          ],
        ),
      ),
    );
  }
}
