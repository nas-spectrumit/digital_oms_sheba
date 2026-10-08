import 'package:digital_oms_sheba/core/providers/app_providers.dart';
import 'package:digital_oms_sheba/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: appProviders,
        child: const MyApp(),
      ),
    );

    // Verify that the title text or key branding element is found on splash
    expect(find.text('ডিজিটাল ওএমএস সেবা'), findsOneWidget);
  });
}
