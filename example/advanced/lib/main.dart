// =============================================================================
// Constructor injection via get_it
// =============================================================================
//
// This example registers AppPreferencesImpl(backend) with get_it so that widgets
// resolve it via getIt<AppPreferencesBase>() — fully decoupled from the
// concrete type and easy to swap for a mock in tests.
//
// For simpler apps that don't need a DI framework, use the singleton instead:
//
//   await AppPreferencesImpl.init();
//   AppPreferencesImpl.instance.counter;   // sync read anywhere in the app
//
// =============================================================================

import 'package:flutter/material.dart';
import 'package:textf/textf.dart';

import 'app_preferences.dart';
import 'service_locator.dart';

/// The main entry point for the application.
///
/// Sets up the service locator before handing control to [MyApp].
/// [AppPreferencesImpl] is registered under [AppPreferencesBase] so widgets
/// depend only on the abstract interface — making them easy to test with mocks.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register AppPreferencesImpl(backend) with get_it.
  // See service_locator.dart for details.
  await setupLocator();

  runApp(const MyApp());
}

/// Root widget.
///
/// Holds theme state so [_MyHomePageState] can toggle it via a callback.
/// Resolves [AppPreferencesBase] from get_it — no concrete type dependency.
class MyApp extends StatefulWidget {
  /// Creates the root application widget.
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Resolved via get_it — only the abstract base type is needed here.
  AppPreferencesBase get _prefs => getIt<AppPreferencesBase>();

  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = _prefs.themeMode;
  }

  Future<void> _cycleTheme() async {
    final next = switch (_themeMode) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    await _prefs.setThemeMode(next);
    setState(() => _themeMode = next);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advanced Example: shared_prefs_typed with get_it',
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: MyHomePage(onCycleTheme: _cycleTheme, themeMode: _themeMode),
    );
  }
}

/// The main page.
///
/// Reads/writes preferences via get_it ([AppPreferencesBase]) and relays
/// theme-cycle requests up to [MyApp] via [onCycleTheme].
class MyHomePage extends StatefulWidget {
  /// Creates the home page.
  const MyHomePage({required this.onCycleTheme, required this.themeMode, super.key});

  /// Callback invoked when the user taps the theme-cycle button.
  final VoidCallback onCycleTheme;

  /// Current theme mode, reflected in the toggle icon.
  final ThemeMode themeMode;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Resolved from get_it — the widget only knows the abstract base type.
  AppPreferencesBase get _prefs => getIt<AppPreferencesBase>();

  late int _counter;
  late String _displayName;

  @override
  void initState() {
    super.initState();
    _counter = _prefs.counter;
    _displayName = _prefs.username ?? 'World';
  }

  Future<void> _incrementCounter() async {
    final next = _counter + 1;
    await _prefs.setCounter(next);
    setState(() => _counter = next);
  }

  Future<void> _resetCounter() async {
    await _prefs.removeCounter();
    setState(() => _counter = _prefs.counter);
  }

  Future<void> _saveName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    await _prefs.setUsername(trimmed);
    setState(() => _displayName = trimmed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, tooltip) = switch (widget.themeMode) {
      ThemeMode.system => (Icons.brightness_auto, 'System theme — tap for Light'),
      ThemeMode.light => (Icons.wb_sunny, 'Light theme — tap for Dark'),
      ThemeMode.dark => (Icons.nightlight_round, 'Dark theme — tap for System'),
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example: shared_prefs_typed with get_it'),
        actions: [
          Tooltip(
            message: tooltip,
            child: IconButton(
              icon: Icon(icon),
              onPressed: widget.onCycleTheme,
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Textf('Hello, *$_displayName*!', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              _NameField(onSave: _saveName),
              const SizedBox(height: 48),
              const Text('Button presses:'),
              Text('$_counter', style: theme.textTheme.displaySmall),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _counter > 0 ? _resetCounter : null,
                child: const Text('Reset counter'),
              ),
              const SizedBox(height: 32),
              const Text(
                'Change theme or name, press the button,\n'
                'then restart the app to see all preferences persist.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Inline widget for editing the display name.
class _NameField extends StatefulWidget {
  const _NameField({required this.onSave});

  final ValueChanged<String> onSave;

  @override
  State<_NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<_NameField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 160,
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Change name…',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onSubmitted: widget.onSave,
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: () => widget.onSave(_controller.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
