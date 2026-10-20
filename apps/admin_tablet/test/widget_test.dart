import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:admin_tablet/main.dart';
import 'package:admin_tablet/features/requests/data/repositories/mock_admin_request_repository.dart';
import 'package:admin_tablet/features/requests/domain/models/admin_request_records.dart';

void main() {
  testWidgets('admin tablet opens overview with labeled sample data', (
    tester,
  ) async {
    await tester.pumpWidget(const FixItAdminApp());
    await tester.pumpAndSettle();

    expect(find.text('Operations overview'), findsOneWidget);
    expect(find.text('SAMPLE DATA'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Requests requiring attention'),
      300,
      scrollable: find
          .descendant(
            of: find.byType(CustomScrollView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
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

  testWidgets('admin reviews, assigns, and reassigns a request with history', (
    tester,
  ) async {
    await tester.pumpWidget(const FixItAdminApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Requests'));
    await tester.pumpAndSettle();
    expect(find.text('Review and assign work orders'), findsOneWidget);
    expect(find.text('REQ-1042'), findsWidgets);

    await tester.tap(find.byKey(const Key('request-search')));
    await tester.enterText(find.byKey(const Key('request-search')), 'REQ-1042');
    await tester.pumpAndSettle();
    expect(find.text('REQ-1042'), findsWidgets);
    expect(find.text('REQ-1041'), findsNothing);

    await tester.ensureVisible(find.byKey(const Key('approve-request-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('approve-request-action')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('request-decision-reason-field')),
      'Request details verified.',
    );
    await tester.tap(find.byKey(const Key('save-request-decision')));
    await tester.pumpAndSettle();
    expect(find.text('Ready to assign'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const Key('assign-technician-action')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('assign-technician-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('request-technician-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Rashid Al Mansoori').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-request-assignment')));
    await tester.pumpAndSettle();
    expect(
      find.text('Assigned technician: Rashid Al Mansoori'),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const Key('reassign-technician-action')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reassign-technician-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('request-technician-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Imran Qureshi').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('assignment-reason-field')),
      'Specialty coverage changed.',
    );
    await tester.tap(find.byKey(const Key('save-request-assignment')));
    await tester.pumpAndSettle();

    expect(find.text('Assigned technician: Imran Qureshi'), findsOneWidget);
    expect(find.text('Technician reassigned'), findsOneWidget);
    expect(find.text('Reason: Specialty coverage changed.'), findsOneWidget);
  });

  testWidgets('appointment updates only after tenant and admin approve', (
    tester,
  ) async {
    await tester.pumpWidget(const FixItAdminApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Requests'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('request-row-REQ-1038')));
    await tester.pumpAndSettle();

    final originalAppointment = tester
        .widget<Text>(find.byKey(const Key('current-appointment')))
        .data!;
    final proposedAppointment = tester
        .widget<Text>(find.textContaining('Proposed:').first)
        .data!
        .replaceFirst('Proposed: ', '');

    await tester.ensureVisible(
      find.byKey(const Key('admin-approve-appointment-action')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('admin-approve-appointment-action')));
    await tester.pumpAndSettle();
    expect(find.text('Admin decision: Approved'), findsOneWidget);
    expect(find.text(originalAppointment), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const Key('tenant-approve-appointment-action')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('tenant-approve-appointment-action')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Current: $proposedAppointment'), findsOneWidget);
    expect(
      find.text('Both approved. Proposed appointment confirmed.'),
      findsOneWidget,
    );
  });

  testWidgets('appointment rejection retains current scheduled time', (
    tester,
  ) async {
    await tester.pumpWidget(const FixItAdminApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Requests'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('request-row-REQ-1038')));
    await tester.pumpAndSettle();

    final originalAppointment = tester
        .widget<Text>(find.byKey(const Key('current-appointment')))
        .data!;
    await tester.ensureVisible(
      find.byKey(const Key('tenant-reject-appointment-action')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('tenant-reject-appointment-action')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('request-decision-reason-field')),
      'The proposed time does not work.',
    );
    await tester.tap(find.byKey(const Key('save-request-decision')));
    await tester.pumpAndSettle();

    expect(find.text(originalAppointment), findsOneWidget);
    expect(
      find.text('Proposal declined. Existing appointment retained.'),
      findsOneWidget,
    );
    expect(
      find.text('Reason: The proposed time does not work.'),
      findsOneWidget,
    );
  });

  testWidgets('admin reviews work, closes, and accepts a timely reopen', (
    tester,
  ) async {
    await tester.pumpWidget(const FixItAdminApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Requests'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('request-row-REQ-1038')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('work-mark-travelling')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('work-mark-travelling')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('work-start')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('work-start')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('work-block')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('work-block')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('request-decision-reason-field')),
      'Waiting for a replacement part.',
    );
    await tester.tap(find.byKey(const Key('save-request-decision')));
    await tester.pumpAndSettle();
    expect(
      find.text('Block reason: Waiting for a replacement part.'),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byKey(const Key('work-resume')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('work-resume')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('work-complete')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('work-complete')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('request-decision-reason-field')),
      'Replaced the valve and tested for leaks.',
    );
    await tester.tap(find.byKey(const Key('save-request-decision')));
    await tester.pumpAndSettle();
    expect(find.text('Elapsed work time: 0 min'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const Key('tenant-accept-completion')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('tenant-accept-completion')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('admin-approve-closure')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('admin-approve-closure')));
    await tester.pumpAndSettle();
    expect(find.text('Closed'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('tenant-request-reopen')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('tenant-request-reopen')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('request-decision-reason-field')),
      'The leak returned the next morning.',
    );
    await tester.tap(find.byKey(const Key('save-request-decision')));
    await tester.pumpAndSettle();
    expect(
      find.text('Reopen reason: The leak returned the next morning.'),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byKey(const Key('admin-accept-reopen')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('admin-accept-reopen')));
    await tester.pumpAndSettle();
    expect(find.text('Reopened'), findsOneWidget);
  });

  test('request reopening is rejected after the 24-hour deadline', () {
    final repository = MockAdminRequestRepository();
    _closeSampleRequest(repository);
    final closedRequest = repository.requests.singleWhere(
      (request) => request.requestNumber == 'REQ-1038',
    );
    final deadline = closedRequest.closedAt!.add(const Duration(hours: 24));

    expect(
      () => repository.requestReopen(
        closedRequest.id,
        'Too late to reopen.',
        now: deadline.add(const Duration(microseconds: 1)),
      ),
      throwsStateError,
    );
    expect(closedRequest.status, WorkRequestStatus.closed);
  });

  testWidgets('notification retry is recorded as preview only', (tester) async {
    await tester.pumpWidget(const FixItAdminApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Notifications'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('notification-preview-notice')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('notification-row-notice-assigned')));
    await tester.pumpAndSettle();
    expect(find.textContaining('No messages are sent.'), findsOneWidget);
    expect(find.text('Noor Ahmed'), findsOneWidget);
    expect(find.text('Imran Qureshi'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const Key('record-notification-retry')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('record-notification-retry')));
    await tester.pumpAndSettle();
    expect(find.textContaining('State: Retry preview queued'), findsOneWidget);
    expect(find.text('Retry previews: 1'), findsOneWidget);
  });

  testWidgets('reports derive status and assignment counts from requests', (
    tester,
  ) async {
    await tester.pumpWidget(const FixItAdminApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reports'));
    await tester.pumpAndSettle();

    expect(find.text('Operational reports'), findsOneWidget);
    expect(
      find.text('LOCAL SAMPLE DATA · Current in-memory snapshot'),
      findsOneWidget,
    );
    expect(find.text('Assignment events'), findsOneWidget);
    expect(find.text('1'), findsWidgets);
    expect(find.text('Appointment outcomes'), findsOneWidget);
  });
}

void _closeSampleRequest(MockAdminRequestRepository repository) {
  final base = DateTime(2026, 10, 20, 9);
  repository.markTravelling('request-1038', now: base);
  repository.startWork(
    'request-1038',
    now: base.add(const Duration(minutes: 5)),
  );
  repository.completeWork(
    'request-1038',
    'Repair complete.',
    now: base.add(const Duration(minutes: 25)),
  );
  repository.recordTenantCompletionDecision(
    'request-1038',
    accepted: true,
    now: base.add(const Duration(minutes: 26)),
  );
  repository.recordAdminClosureDecision(
    'request-1038',
    approved: true,
    now: base.add(const Duration(minutes: 27)),
  );
}
