/// Integration tests for the advanced get_it example.
///
/// These tests exercise the generated [AppPreferences] class using **constructor
/// injection** — no get_it setup is needed. This demonstrates the key benefit of
/// the public constructor: clean, isolated test instances without global state.
library;

import 'package:advanced_example/app_preferences.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Provide an in-memory platform store — no native plugins needed in tests.
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });

  // Helper to clear the in-memory store between tests.
  Future<void> clearStore() async {
    await SharedPreferencesAsyncPlatform.instance?.clear(
      const ClearPreferencesParameters(filter: PreferencesFilters()),
      const SharedPreferencesOptions(),
    );
  }

  group('AppPreferences — constructor injection (no get_it required)', () {
    late AppPreferences prefs;

    setUp(() async {
      await clearStore();
      final backend = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      // Public constructor: pass the backend directly.
      // No global init() call, no singleton touched.
      prefs = AppPreferences(backend);
    });

    tearDown(AppPreferences.resetInstance);

    group('counter (int, default 0)', () {
      test('returns default initially', () {
        expect(prefs.counter, 0);
        expect(prefs.isSetCounter(), isFalse);
      });

      test('sets and retrieves a value', () async {
        await prefs.setCounter(5);
        expect(prefs.counter, 5);
        expect(prefs.isSetCounter(), isTrue);
      });

      test('remove reverts to default', () async {
        await prefs.setCounter(5);
        await prefs.removeCounter();
        expect(prefs.counter, 0);
        expect(prefs.isSetCounter(), isFalse);
      });
    });

    group('isDarkMode (bool, default false)', () {
      test('returns default initially', () {
        expect(prefs.isDarkMode, isFalse);
        expect(prefs.isSetIsDarkMode(), isFalse);
      });

      test('sets and retrieves a value', () async {
        await prefs.setIsDarkMode(true);
        expect(prefs.isDarkMode, isTrue);
        expect(prefs.isSetIsDarkMode(), isTrue);
      });

      test('remove reverts to default', () async {
        await prefs.setIsDarkMode(true);
        await prefs.removeIsDarkMode();
        expect(prefs.isDarkMode, isFalse);
        expect(prefs.isSetIsDarkMode(), isFalse);
      });
    });

    group('username (String?, default null)', () {
      test('returns null initially', () {
        expect(prefs.username, isNull);
        expect(prefs.isSetUsername(), isFalse);
      });

      test('sets and retrieves a value', () async {
        await prefs.setUsername('Alice');
        expect(prefs.username, 'Alice');
        expect(prefs.isSetUsername(), isTrue);
      });

      test('setting to null removes the key', () async {
        await prefs.setUsername('Alice');
        await prefs.setUsername(null);
        expect(prefs.username, isNull);
        expect(prefs.isSetUsername(), isFalse);
      });
    });

    test('each test has an independent instance — no shared state', () {
      // Constructing AppPreferences(backend) never touches _instance,
      // so the singleton and this instance are fully independent.
      expect(prefs.counter, 0);
    });

    test('instance getter throws StateError before init()', () {
      AppPreferences.resetInstance();
      expect(() => AppPreferences.instance, throwsStateError);
    });
  });

  group('AppPreferences satisfies AppPreferencesBase — get_it type compatibility', () {
    test('AppPreferences can be assigned to AppPreferencesBase', () async {
      await clearStore();
      final backend = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      // This is exactly what service_locator.dart does:
      //   getIt.registerSingleton<AppPreferencesBase>(AppPreferences(backend))
      final prefs = AppPreferences(backend);
      expect(prefs, isA<AppPreferencesBase>());
      await prefs.setCounter(99);
      expect(prefs.counter, 99);
      AppPreferences.resetInstance();
    });
  });
}
