import 'package:flutter/material.dart';
import 'package:textf/textf.dart';

import 'app_preferences.g.dart';
import 'service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register services. The AppPreferences public constructor receives the
  // storage backend here — no global init() call needed anywhere else.
  await setupLocator();

  runApp(const MyApp());
}

/// Root widget. Holds theme state so [_MyHomePageState] can toggle it via
/// a callback without any navigation tricks.
class MyApp extends StatefulWidget {
  /// Creates the root application widget.
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Resolved via get_it — only the abstract base type is needed here.
  AppPreferencesBase get _prefs => getIt<AppPreferencesBase>();

  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = _prefs.isDarkMode;
  }

  Future<void> _toggleTheme() async {
    final next = !_isDarkMode;
    await _prefs.setIsDarkMode(next);
    setState(() => _isDarkMode = next);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advanced Example: shared_prefs_typed with get_it',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
      home: MyHomePage(onToggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
    );
  }
}

/// The main page. Reads/writes preferences via get_it and relays theme
/// toggle requests up to [MyApp] via [onToggleTheme].
class MyHomePage extends StatefulWidget {
  /// Creates the home page.
  const MyHomePage({required this.onToggleTheme, required this.isDarkMode, super.key});

  /// Callback invoked when the user taps the theme-toggle button.
  final VoidCallback onToggleTheme;

  /// Current dark-mode state, reflected in the toggle icon.
  final bool isDarkMode;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example: shared_prefs_typed with get_it'),
        actions: [
          Tooltip(
            message: widget.isDarkMode ? 'Switch to light' : 'Switch to dark',
            child: IconButton(
              icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: widget.onToggleTheme,
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
