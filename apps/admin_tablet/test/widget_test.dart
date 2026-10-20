import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:admin_tablet/main.dart';

void main() {
  testWidgets('admin tablet opens overview with labeled sample data', (
    tester,
  ) async {
    await tester.pumpWidget(const FixItAdminApp());
    await tester.pumpAndSettle();

    expect(find.text('Operations overview'), findsOneWidget);
    expect(find.text('SAMPLE DATA'), findsOneWidget);
    expect(find.text('Requests requiring attention'), findsOneWidget);
  });

  testWidgets('property section lists sample hierarchy and creates a unit', (
    tester,
  ) async {
    await tester.pumpWidget(const FixItAdminApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Properties'));
    await tester.pumpAndSettle();

    expect(find.text('Property hierarchy'), findsOneWidget);
    expect(find.text('Marina Campus'), findsOneWidget);
    await tester.tap(find.text('Buildings / blocks'));
    await tester.pumpAndSettle();
    expect(find.text('Tower 1 · Tower'), findsOneWidget);

    await tester.tap(find.text('Apartments').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add apartment'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('apartment-unit-field')),
      'A-999',
    );
    await tester.enterText(find.byType(TextField).last, '9');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('A-999'), findsOneWidget);
  });
}
