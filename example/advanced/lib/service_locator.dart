import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_preferences.g.dart';

/// The global service locator instance.
final GetIt getIt = GetIt.instance;

/// Registers all application services with [getIt].
///
/// Call once at app startup before `runApp`.
///
/// The public `AppPreferencesImpl(backend)` constructor is used here to receive
/// the storage backend directly. This keeps lifecycle management explicit and
/// the rest of the app decoupled from the concrete type via [AppPreferencesImplBase].
///
/// **Alternative — singleton** (for apps that don't use a DI framework):
/// ```dart
/// await AppPreferencesImpl.init();
/// // Then access via AppPreferencesImpl.instance anywhere.
/// ```
Future<void> setupLocator() async {
  final backend = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );
  // Register AppPreferences under its abstract base type.
  // Any widget that calls getIt<AppPreferencesImplBase>() receives this instance.
  getIt.registerSingleton<AppPreferencesImplBase>(AppPreferencesImpl(backend));
}
