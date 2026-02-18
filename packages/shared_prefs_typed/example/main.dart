// ignore_for_file: unused_element, unused_field

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_prefs_typed_annotations/shared_prefs_typed_annotations.dart';

// main.g.dart is produced by `flutter pub run build_runner build`.
import 'main.g.dart';

/// Defines the preference schema for this app.
///
/// The generator reads the `static const` fields and produces [SettingsPrefs]
/// in `main.g.dart`.
@TypedPrefs()
abstract class _SettingsPrefs {
  /// Theme override.
  ///
  /// - `true`  → [ThemeMode.light]
  /// - `false` → [ThemeMode.dark]
  /// - `null`  → [ThemeMode.system] (default)
  static const bool? isLight = null;

  /// Recently viewed item IDs, stored newest-first.
  ///
  /// `List<int>` is transparently serialized to `List<String>` in storage
  /// and parsed back with `int.parse` on read — all handled by the generator.
  static const List<int> recentItemIds = <int>[];
}

// =============================================================================
// Two ways to instantiate the generated class
// =============================================================================
//
// ① SINGLETON (simple apps)
//   Call `await SettingsPrefs.init()` once at startup.
//   The instance is then available via `SettingsPrefs.instance` everywhere.
//
//     await SettingsPrefs.init();
//     SettingsPrefs.instance.isLight;           // sync read
//     await SettingsPrefs.instance.setIsLight(true); // async write
//
// ② CONSTRUCTOR (dependency injection / testing)
//   Pass the storage backend directly — no global state touched.
//
//     final backend = await SharedPreferencesWithCache.create(
//       cacheOptions: const SharedPreferencesWithCacheOptions(),
//     );
//     final prefs = SettingsPrefs(backend);
//     runApp(MyApp(prefs: prefs));
//
// =============================================================================

/// Entry point demonstrating the **singleton** approach.
///
/// The companion [MyAppDI] class (below) demonstrates the
/// **constructor-injection** approach.
Future<void> main() async {
  // Required before any plugin is used.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize once. Concurrent callers share the same Future — no race
  // conditions. After the await, `SettingsPrefs.instance` is available.
  await SettingsPrefs.init();

  runApp(const MyApp());
}

// =============================================================================
// Singleton approach — MyApp reads SettingsPrefs.instance directly.
// =============================================================================

/// Root widget for the **singleton** example.
class MyApp extends StatefulWidget {
  /// Creates the root application widget.
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Access the singleton — safe because init() completed before runApp().
  SettingsPrefs get _prefs => SettingsPrefs.instance;

  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = _themeModeFor(_prefs.isLight);
  }

  Future<void> _changeTheme(bool? isLight) async {
    await _prefs.setIsLight(isLight);
    setState(() => _themeMode = _themeModeFor(isLight));
  }

  // Example: prepend an item ID and keep at most 5 recent entries.
  Future<void> _recordVisit(int itemId) async {
    final updated = [itemId, ..._prefs.recentItemIds].take(5).toList();
    await _prefs.setRecentItemIds(updated);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theme Demo — singleton',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: _ThemeSelector(
        current: _prefs.isLight,
        onChanged: _changeTheme,
      ),
    );
  }
}

// =============================================================================
// Constructor-injection approach — SettingsPrefs is passed from main().
// =============================================================================

/// Entry point demonstrating the **constructor-injection** approach.
///
/// Use this pattern when you want explicit lifecycle control, or when writing
/// tests (pass a mock / in-memory backend instead of the real one).
Future<void> mainDI() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create the storage backend once — own its lifecycle explicitly.
  final backend = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );

  // Inject the backend via the public const constructor.
  // No global singleton is touched.
  final prefs = SettingsPrefs(backend);

  runApp(MyAppDI(prefs: prefs));
}

/// Root widget for the **constructor-injection** example.
class MyAppDI extends StatefulWidget {
  /// Creates the root widget with an explicit [prefs] instance.
  const MyAppDI({required this.prefs, super.key});

  /// The preferences service, injected by the caller.
  final SettingsPrefs prefs;

  @override
  State<MyAppDI> createState() => _MyAppDIState();
}

class _MyAppDIState extends State<MyAppDI> {
  SettingsPrefs get _prefs => widget.prefs;

  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = _themeModeFor(_prefs.isLight);
  }

  Future<void> _changeTheme(bool? isLight) async {
    await _prefs.setIsLight(isLight);
    setState(() => _themeMode = _themeModeFor(isLight));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theme Demo — constructor injection',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: _ThemeSelector(
        current: _prefs.isLight,
        onChanged: _changeTheme,
      ),
    );
  }
}

// =============================================================================
// Shared UI
// =============================================================================

/// Converts the stored `bool?` preference to a [ThemeMode].
ThemeMode _themeModeFor(bool? isLight) => switch (isLight) {
      true => ThemeMode.light,
      false => ThemeMode.dark,
      null => ThemeMode.system,
    };

/// A [SegmentedButton] for picking System / Light / Dark.
class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({required this.current, required this.onChanged});

  final bool? current;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Selector')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Choose your theme:', style: TextStyle(fontSize: 18)),
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
              selected: {current},
              onSelectionChanged: (s) => onChanged(s.first),
            ),
          ],
        ),
      ),
    );
  }
}
