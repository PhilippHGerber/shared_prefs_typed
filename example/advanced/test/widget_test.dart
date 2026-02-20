/// Smoke test for the advanced example app.
///
/// For full preference-layer coverage, see app_preferences_test.dart.
library;

import 'package:advanced_example/app_preferences.dart';
import 'package:advanced_example/main.dart';
import 'package:advanced_example/service_locator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });

  setUp(() async => setupLocator());

  tearDown(() async {
    AppPreferencesImpl.resetInstance();
    await getIt.reset();
  });

  testWidgets('app renders without errors', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Example: shared_prefs_typed with get_it'), findsOneWidget);
  });
}
