import 'package:crypto_trader/import_facade/ui.dart';
import 'package:flutter_test/flutter_test.dart';

// TODO(bug): The test is not passing.
void main() {
  testWidgets('Overall page loads (smoke test)', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(Portfolio());
    await tester.pumpAndSettle(); // Allow Futures to complete.

    expect(find.text('Portfolio'), findsOneWidget);
  });
}
