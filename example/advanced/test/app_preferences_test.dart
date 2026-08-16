/// Integration tests for the advanced get_it example.
///
/// These tests exercise the generated [AppPreferencesImpl] class using **constructor
/// injection** — no get_it setup is needed. This demonstrates the key benefit of
/// the public constructor: clean, isolated test instances without global state.
library;

import 'package:advanced_example/app_preferences.dart';
import 'package:flutter/material.dart';
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
    late AppPreferencesImpl prefs;

    setUp(() async {
      await clearStore();
      final backend = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      // Public constructor: pass the backend directly.
      // No global init() call, no singleton touched.
      prefs = AppPreferencesImpl(backend);
    });

    tearDown(AppPreferencesImpl.resetInstance);

    group('counter (int, default 0)', () {
      test('returns default initially', () {
        expect(prefs.counter, 0);
        expect(prefs.containsCounter(), isFalse);
      });

      test('sets and retrieves a value', () async {
        await prefs.setCounter(5);
        expect(prefs.counter, 5);
        expect(prefs.containsCounter(), isTrue);
      });

      test('remove reverts to default', () async {
        await prefs.setCounter(5);
        await prefs.removeCounter();
        expect(prefs.counter, 0);
        expect(prefs.containsCounter(), isFalse);
      });
    });

    group('themeMode (ThemeMode, default ThemeMode.system)', () {
      test('returns default initially', () {
        expect(prefs.themeMode, ThemeMode.system);
        expect(prefs.containsThemeMode(), isFalse);
      });

      test('sets and retrieves a value', () async {
        await prefs.setThemeMode(ThemeMode.dark);
        expect(prefs.themeMode, ThemeMode.dark);
        expect(prefs.containsThemeMode(), isTrue);
      });

      test('remove reverts to default', () async {
        await prefs.setThemeMode(ThemeMode.dark);
        await prefs.removeThemeMode();
        expect(prefs.themeMode, ThemeMode.system);
        expect(prefs.containsThemeMode(), isFalse);
      });

      test('falls back to default on invalid enum name and invokes onReadError', () async {
        await SharedPreferencesAsyncPlatform.instance!.setString(
          'themeMode',
          'nonExistentMode',
          const SharedPreferencesOptions(),
        );

        String? capturedKey;
        Object? capturedError;
        final backend = await SharedPreferencesWithCache.create(
          cacheOptions: const SharedPreferencesWithCacheOptions(),
        );
        final instance = AppPreferencesImpl(
          backend,
          onReadError: (key, error) {
            capturedKey = key;
            capturedError = error;
          },
        );

        final result = instance.themeMode;

        expect(result, ThemeMode.system);
        expect(capturedKey, 'themeMode');
        expect(capturedError, isA<ArgumentError>());
      });

      test('falls back to default on type mismatch (int stored) and invokes onReadError', () async {
        await SharedPreferencesAsyncPlatform.instance!.setInt(
          'themeMode',
          1,
          const SharedPreferencesOptions(),
        );

        String? capturedKey;
        Object? capturedError;
        final backend = await SharedPreferencesWithCache.create(
          cacheOptions: const SharedPreferencesWithCacheOptions(),
        );
        final instance = AppPreferencesImpl(
          backend,
          onReadError: (key, error) {
            capturedKey = key;
            capturedError = error;
          },
        );

        final result = instance.themeMode;

        expect(result, ThemeMode.system);
        expect(capturedKey, 'themeMode');
        expect(capturedError, isNotNull);
      });
    });

    group('username (String?, default null)', () {
      test('returns null initially', () {
        expect(prefs.username, isNull);
        expect(prefs.containsUsername(), isFalse);
      });

      test('sets and retrieves a value', () async {
        await prefs.setUsername('Alice');
        expect(prefs.username, 'Alice');
        expect(prefs.containsUsername(), isTrue);
      });

      test('setting to null removes the key', () async {
        await prefs.setUsername('Alice');
        await prefs.setUsername(null);
        expect(prefs.username, isNull);
        expect(prefs.containsUsername(), isFalse);
      });
    });

    test('each test has an independent instance — no shared state', () {
      // Constructing AppPreferencesImpl(backend) never touches _instance,
      // so the singleton and this instance are fully independent.
      expect(prefs.counter, 0);
    });

    test('instance getter throws StateError before init()', () {
      AppPreferencesImpl.resetInstance();
      expect(() => AppPreferencesImpl.instance, throwsStateError);
    });
  });

  group('AppPreferences satisfies AppPreferencesBase — get_it type compatibility', () {
    test('AppPreferences can be assigned to AppPreferencesBase', () async {
      await clearStore();
      final backend = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(),
      );
      // This is exactly what service_locator.dart does:
      //   getIt.registerSingleton<AppPreferencesBase>(AppPreferencesImpl(backend))
      final prefs = AppPreferencesImpl(backend);
      expect(prefs, isA<AppPreferencesBase>());
      await prefs.setCounter(99);
      expect(prefs.counter, 99);
      AppPreferencesImpl.resetInstance();
    });
  });
}
