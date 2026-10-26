import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:longdrop/main.dart';

void main() {
  testWidgets('Home navigates to the three screens', (tester) async {
    await tester.pumpWidget(const LongdropApp());
    expect(find.text('Longdrop'), findsOneWidget);

    for (final label in ['My ID', 'Send File', 'Receive File']) {
      await tester.tap(find.text(label));
      // Receive screen has an endless spinner, so avoid pumpAndSettle.
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text(label), findsOneWidget);
      expect(find.text('Longdrop'), findsNothing);
      await tester.tap(find.byTooltip('Back'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Longdrop'), findsOneWidget);
    }
  });

  testWidgets('Send mockup: Connect needs a file and a peer ID, then completes',
      (tester) async {
    await tester.pumpWidget(const LongdropApp());
    await tester.tap(find.text('Send File'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    FilledButton connect() =>
        tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Connect'));
    expect(connect().onPressed, isNull);

    await tester.tap(find.text('Choose file'));
    await tester.pump();
    expect(connect().onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'some-peer-id');
    await tester.pump();
    expect(connect().onPressed, isNotNull);

    await tester.tap(find.text('Connect'));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Keep the app open until the transfer finishes.'),
        findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    expect(find.text('Send another'), findsOneWidget);
  });

  testWidgets('Receive mockup: request can be accepted and completes',
      (tester) async {
    await tester.pumpWidget(const LongdropApp());
    await tester.tap(find.text('Receive File'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('Simulate incoming request (mockup)'));
    await tester.pump();
    expect(find.text('Incoming request'), findsOneWidget);

    await tester.tap(find.text('Accept'));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Keep the app open until the transfer finishes.'),
        findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    expect(find.text('Done'), findsOneWidget);
  });
}
