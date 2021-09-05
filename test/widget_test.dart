// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/widgets/app_dependencies.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Overall page loads (smoke test)', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(AppDependencies(
      prices: Prices.fake(),
      trader: Trader.fake(),
    ));

    expect(find.text('Bitcoin price:'), findsOneWidget);

    // TODO Tap the Coin icon and trigger a frame once it's implemented
    // await tester.tap(find.byIcon(Icons.monetization_on_outlined));
    // await tester.pump();
  });
}
