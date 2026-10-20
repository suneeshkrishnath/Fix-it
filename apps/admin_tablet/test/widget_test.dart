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

  testWidgets(
    'tenant can be added to a listed apartment with agreement placeholder',
    (tester) async {
      await tester.pumpWidget(const FixItAdminApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tenants'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('add-tenant-action')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('tenant-name-field')),
        'Fatima Noor',
      );
      await tester.enterText(
        find.byKey(const Key('tenant-phone-field')),
        '+971 50 555 0101',
      );
      await tester.enterText(
        find.byKey(const Key('tenant-email-field')),
        'fatima.noor@example.test',
      );

      await tester.tap(find.byKey(const Key('tenant-apartment-field')));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('A-302').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('agreement-placeholder')));
      await tester.pumpAndSettle();
      expect(find.text('Upload planned'), findsOneWidget);

      await tester.tap(find.byKey(const Key('save-tenant')));
      await tester.pumpAndSettle();

      expect(find.text('Fatima Noor'), findsOneWidget);
      expect(find.textContaining('A-302'), findsNWidgets(2));
    },
  );

  testWidgets('admin can add technician and permission role', (tester) async {
    await tester.pumpWidget(const FixItAdminApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Technicians'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('add-technician-action')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('technician-login-id-field')),
      'tech-003',
    );
    await tester.enterText(
      find.byKey(const Key('technician-name-field')),
      'Saba Khan',
    );
    await tester.enterText(
      find.byKey(const Key('technician-phone-field')),
      '+971 50 222 3333',
    );
    await tester.enterText(
      find.byKey(const Key('technician-specialty-field')),
      'HVAC',
    );
    await tester.tap(find.byKey(const Key('save-technician')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Saba Khan'), findsOneWidget);

    await tester.tap(find.text('Roles and permissions'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('add-role-action')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('role-name-field')),
      'Campus Viewer',
    );
    await tester.tap(find.text('View operational reports'));
    await tester.tap(find.byKey(const Key('save-role')));
    await tester.pumpAndSettle();
    expect(find.text('Campus Viewer'), findsOneWidget);
  });
}
