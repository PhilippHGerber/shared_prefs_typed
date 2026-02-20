// ignore_for_file: unreachable_from_main // Definition for generated code.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

part 'theme_example.g.dart';

/// Defines the data contract for the application's settings preferences.
@TypedPrefs()
abstract class SettingsPrefs {
  /// The app's theme mode, stored as the enum's `.name` string.
  static const ThemeMode themeMode = ThemeMode.system;
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
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = SettingsPrefsImpl.instance.themeMode;
  }

  /// Updates the theme, persists the choice, and rebuilds the UI.
  Future<void> _changeTheme(ThemeMode newThemeMode) async {
    await SettingsPrefsImpl.instance.setThemeMode(newThemeMode);
    setState(() => _themeMode = newThemeMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Theme Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: MyHomePage(
        currentThemeMode: SettingsPrefsImpl.instance.themeMode,
        onThemeChanged: _changeTheme,
      ),
    );
  }
}

// --- UI Screen Widget ---

/// The home page of the application, responsible for displaying the UI.
class MyHomePage extends StatelessWidget {
  /// Creates the home page widget.
  const MyHomePage({
    required this.currentThemeMode,
    required this.onThemeChanged,
    super.key,
  });

  /// The currently selected [ThemeMode].
  final ThemeMode currentThemeMode;

  /// A callback function to notify the parent widget of a theme change.
  final ValueChanged<ThemeMode> onThemeChanged;

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
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('System'),
                  icon: Icon(Icons.brightness_auto),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('Light'),
                  icon: Icon(Icons.wb_sunny),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('Dark'),
                  icon: Icon(Icons.nightlight_round),
                ),
              ],
              selected: {currentThemeMode},
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
