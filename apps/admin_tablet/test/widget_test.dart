import 'package:flutter_test/flutter_test.dart';

import 'package:admin_tablet/main.dart';

void main() {
  testWidgets('admin tablet opens overview with labeled sample data',
      (tester) async {
    await tester.pumpWidget(const FixItAdminApp());
    await tester.pumpAndSettle();

    expect(find.text('Operations overview'), findsOneWidget);
    expect(find.text('SAMPLE DATA'), findsOneWidget);
    expect(find.text('Requests requiring attention'), findsOneWidget);
  });

  testWidgets('admin navigation opens planned properties section',
      (tester) async {
    await tester.pumpWidget(const FixItAdminApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Properties'));
    await tester.pumpAndSettle();

    expect(find.text('Property hierarchy'), findsOneWidget);
    expect(find.text('Planned'), findsOneWidget);
  });
}
