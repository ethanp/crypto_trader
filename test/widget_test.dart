// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:crypto_trader/widgets/app_config/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Overall page loads (smoke test)', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(AppTheme());
    await tester.pumpAndSettle(); // Allow Futures to complete.

    expect(find.text('Portfolio'), findsOneWidget);
  });
}
