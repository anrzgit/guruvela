import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guruvela_app/app.dart';
import 'package:guruvela_app/providers/core_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App boots to the home screen in mock mode', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const GuruvelaApp(),
      ),
    );
    // Let async providers (featured mentors) settle.
    await tester.pump(const Duration(milliseconds: 500));

    // Hero CTA and bottom nav should be present.
    expect(find.text('Start Predicting'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
  });
}
