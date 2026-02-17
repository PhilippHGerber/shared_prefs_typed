import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_preferences.g.dart';

/// The global service locator instance.
final GetIt getIt = GetIt.instance;

/// Registers all application services with [getIt].
///
/// Call once at app startup before `runApp`. The public constructor accepts a
/// storage backend directly — no global `init()` needed. The concrete type is
/// registered under the abstract base so the rest of the app stays decoupled.
Future<void> setupLocator() async {
  final backend = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );
  getIt.registerSingleton<AppPreferencesBase>(AppPreferences(backend));
}
