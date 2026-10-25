import 'package:flutter_test/flutter_test.dart';
import 'package:longdrop/main.dart';

void main() {
  testWidgets('Home navigates to the three screens', (tester) async {
    await tester.pumpWidget(const LongdropApp());
    expect(find.text('Longdrop'), findsOneWidget);

    for (final label in ['My ID', 'Send File', 'Receive File']) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(find.text(label), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
  });
}
