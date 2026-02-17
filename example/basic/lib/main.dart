// example/lib/main.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_preferences.g.dart';

/// The main entry point for the application.
///
/// Creates the preferences backend and injects it via the [AppPreferences]
/// constructor. This keeps the preferences service lifecycle explicit and
/// makes the app straightforward to test without global state.
Future<void> main() async {
  // Required for plugin initialization before runApp().
  WidgetsFlutterBinding.ensureInitialized();

  // Create the storage backend once on startup.
  final backend = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );

  // Construct the preferences service by passing the backend directly.
  final prefs = AppPreferences(backend);

  runApp(MyApp(prefs: prefs));
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  /// Creates the root application widget.
  const MyApp({required this.prefs, super.key});

  /// The preferences service instance, injected from [main].
  final AppPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stateful Counter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: MyHomePage(prefs: prefs),
    );
  }
}

/// The main page of the application, demonstrating a seamless, auto-saving UI.
class MyHomePage extends StatefulWidget {
  /// Creates the home page widget.
  const MyHomePage({required this.prefs, super.key});

  /// The preferences service instance, injected by the parent.
  final AppPreferences prefs;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Local state variables to hold the current values for the UI.
  // They are initialized from SharedPreferences in `initState`.
  late int _counter;
  late String _greeting;

  // A controller to manage the text in the name input field.
  late final TextEditingController _nameController;

  // A FocusNode to detect when the user taps away from the text field.
  late final FocusNode _nameFocusNode;

  AppPreferences get _prefs => widget.prefs;

  @override
  void initState() {
    super.initState();

    // Initialize the local state from the persistent storage.
    _counter = _prefs.counter;
    _greeting = _prefs.displayGreeting ?? 'World';

    // Set up the text controller with the currently stored name.
    _nameController = TextEditingController(text: _greeting);

    // Set up the FocusNode and add a listener to trigger auto-save.
    _nameFocusNode = FocusNode();
    _nameFocusNode.addListener(_onGreetingFocusChange);
  }

  @override
  void dispose() {
    // It's crucial to dispose of controllers and focus nodes to free up resources
    // and prevent memory leaks.
    _nameController.dispose();
    _nameFocusNode
      ..removeListener(_onGreetingFocusChange)
      ..dispose();
    super.dispose();
  }

  /// Listener that triggers when the focus on the greeting field changes.
  Future<void> _onGreetingFocusChange() async {
    // If the field has lost focus, save the new name.
    if (!_nameFocusNode.hasFocus) {
      await _saveGreeting();
    }
  }

  /// Saves the new greeting from the text field if it has changed.
  Future<void> _saveGreeting() async {
    final newGreeting = _nameController.text.trim();

    // Only save if the name is not empty and has actually changed.
    if (newGreeting.isNotEmpty && newGreeting != _greeting) {
      // Persist the new displayGreeting.
      await _prefs.setDisplayGreeting(newGreeting);

      // Update the local state to reflect the change in the UI.
      setState(() {
        _greeting = newGreeting;
      });
      // Show a snackbar to confirm the change.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Greeting updated to "$newGreeting"'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      // If the name was invalid or unchanged, reset the text field
      // to the last known good value.
      _nameController.text = _greeting;
    }
  }

  /// Increments the counter, updates the UI, and persists the new value.
  Future<void> _incrementCounter() async {
    final newCounter = _counter + 1;
    // Persist the change asynchronously.
    await _prefs.setCounter(newCounter);

    // Update the local state to trigger a UI rebuild immediately.
    setState(() {
      _counter = newCounter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final headlineStyle = textTheme.headlineMedium?.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Preferences Typed'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // --- INLINE GREETING & EDITING WIDGET ---
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('Hello, ', style: headlineStyle),
                  Flexible(
                    child: TextField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      style: headlineStyle,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5),
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: (_) => _saveGreeting(),
                    ),
                  ),
                  Text(' !', style: headlineStyle),
                ],
              ),
              const SizedBox(height: 80),

              // --- COUNTER DISPLAY SECTION ---
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: textTheme.headlineMedium,
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
