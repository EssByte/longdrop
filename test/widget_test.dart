import 'package:flutter_test/flutter_test.dart';
import 'package:longdrop/main.dart';

void main() {
  testWidgets('Home navigates to the three screens', (tester) async {
    await tester.pumpWidget(const LongdropApp());
    expect(find.text('Longdrop'), findsOneWidget);

    for (final label in ['My ID', 'Send File', 'Receive File']) {
      await tester.tap(find.text(label));
      // Receive screen has an endless spinner, so avoid pumpAndSettle.
      await tester.pump(const Duration(seconds: 1));
      expect(find.text(label), findsOneWidget);
      await tester.pageBack();
      await tester.pump(const Duration(seconds: 1));
    }
  });
}
