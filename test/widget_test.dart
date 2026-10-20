import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fix_it/app/app.dart';
import 'package:fix_it/features/auth/domain/models/resident.dart';
import 'package:fix_it/features/auth/domain/repositories/auth_repository.dart';
import 'package:fix_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:fix_it/features/move_out/domain/models/move_out_request.dart';
import 'package:fix_it/features/move_out/domain/repositories/move_out_repository.dart';
import 'package:fix_it/features/move_out/presentation/providers/move_out_providers.dart';
import 'package:fix_it/features/requests/domain/models/service_request.dart';
import 'package:fix_it/features/requests/domain/repositories/service_request_repository.dart';
import 'package:fix_it/features/requests/presentation/providers/service_request_providers.dart';
import 'package:fix_it/features/technician/domain/repositories/technician_session_repository.dart';
import 'package:fix_it/features/technician/data/repositories/mock_technician_assignment_repository.dart';
import 'package:fix_it/features/technician/domain/repositories/technician_assignment_repository.dart';
import 'package:fix_it/features/technician/presentation/providers/technician_providers.dart';

void main() {
  testWidgets('resident can request and verify a mock OTP', (tester) async {
    final repository = _FakeAuthRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: const FixItApp(),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('phone-field')),
      '+48 500000000',
    );
    await tester.enterText(find.byKey(const Key('apartment-field')), 'A-302');
    await tester.tap(find.text('Send verification code'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your verification code'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('otp-field')), '123456');
    await tester.tap(find.text('Verify and continue'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, Anna Kowalska'), findsOneWidget);
    expect(find.text('Apartment A-302'), findsOneWidget);
  });

  testWidgets('invalid resident details show an error', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
        ],
        child: const FixItApp(),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('phone-field')),
      '+48 111111111',
    );
    await tester.enterText(find.byKey(const Key('apartment-field')), 'B-404');
    await tester.tap(find.text('Send verification code'));
    await tester.pumpAndSettle();

    expect(find.text('Resident details were not recognized.'), findsOneWidget);
  });

  testWidgets('technician can sign in and review assigned jobs and history', (
    tester,
  ) async {
    final requestRepository = _FakeServiceRequestRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
          serviceRequestRepositoryProvider.overrideWithValue(requestRepository),
          technicianSessionRepositoryProvider.overrideWithValue(
            _FakeTechnicianSessionRepository(),
          ),
        ],
        child: const FixItApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Technician sign in'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('technician-id-field')),
      'TECH-001',
    );
    await tester.tap(find.byKey(const Key('technician-sign-in')));
    await tester.pumpAndSettle();

    expect(find.text('Technician jobs'), findsOneWidget);
    expect(find.textContaining('Water leakage'), findsOneWidget);
    await tester.tap(find.text('Work history'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Switch maintenance'), findsOneWidget);
    expect(
      requestRepository.requests.where((item) => item.isSample),
      hasLength(2),
    );
    await tester.tap(find.text('Workflow examples'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('workflow-sample-workAccepted')),
      findsOneWidget,
    );
    expect(find.text('Tenant notification preview'), findsWidgets);
    expect(find.text('Administrator notification preview'), findsWidgets);
  });

  test(
    'appointment proposal applies only after tenant and admin approve',
    () async {
      final originalAppointment = DateTime(2026, 10, 20, 10);
      final proposedAppointment = DateTime(2026, 10, 22, 14);
      final requestRepository = _FakeServiceRequestRepository()
        ..requests.add(
          ServiceRequest(
            id: 'assigned-1',
            requestNumber: 'FX-ASSIGNED-1',
            category: 'Plumbing',
            subcategory: 'Water leakage',
            description: 'Repair a leak.',
            priority: ServicePriority.normal,
            createdAt: DateTime(2026, 10, 18),
            status: ServiceRequestStatus.appointmentScheduled,
            assignedTechnicianId: 'TECH-001',
            appointmentAt: originalAppointment,
          ),
        );
      final assignments = MockTechnicianAssignmentRepository(requestRepository);

      await assignments.proposeAppointmentChange(
        'assigned-1',
        proposedAppointment,
      );
      await assignments.recordAppointmentDecision(
        requestId: 'assigned-1',
        decision: AppointmentProposalDecision.approve,
        byAdministrator: false,
      );
      expect(
        requestRepository.requests.single.appointmentAt,
        originalAppointment,
      );
      expect(
        requestRepository.requests.single.tenantApprovedAppointmentChange,
        isTrue,
      );
      expect(
        requestRepository.requests.single.adminApprovedAppointmentChange,
        isFalse,
      );

      await assignments.recordAppointmentDecision(
        requestId: 'assigned-1',
        decision: AppointmentProposalDecision.approve,
        byAdministrator: true,
      );
      expect(
        requestRepository.requests.single.appointmentAt,
        proposedAppointment,
      );
      expect(requestRepository.requests.single.proposedAppointmentAt, isNull);
    },
  );

  testWidgets('tenant closes technician-completed work and can reopen it', (
    tester,
  ) async {
    final requestRepository = _FakeServiceRequestRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
          serviceRequestRepositoryProvider.overrideWithValue(requestRepository),
          technicianSessionRepositoryProvider.overrideWithValue(
            _FakeTechnicianSessionRepository(),
          ),
        ],
        child: const FixItApp(),
      ),
    );
    await tester.pumpAndSettle();
    await _signInAsTechnician(tester);
    await tester.tap(find.byKey(const Key('technician-job-request-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('accept-assignment')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('start-work')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('complete-work')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('completion-comments-field')),
      'Repaired and tested.',
    );
    await tester.tap(find.byKey(const Key('confirm-completion')));
    await tester.pumpAndSettle();

    final completed = requestRepository.requests.first;
    expect(completed.status, ServiceRequestStatus.awaitingTenantConfirmation);
    expect(completed.closedAt, isNull);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Sign out'));
    await tester.pumpAndSettle();
    await _signInAsResident(tester);
    await tester.tap(find.byKey(const Key('my-requests-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('request-request-1')));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).last, const Offset(0, -320));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('tenant-close-request')));
    await tester.pumpAndSettle();
    expect(
      requestRepository.requests.first.status,
      ServiceRequestStatus.closed,
    );
    expect(requestRepository.requests.first.closedAt, isNotNull);
    await tester.drag(find.byType(ListView).last, const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('Closed by tenant'), findsOneWidget);
    expect(find.text('The 24-hour reopen window has expired.'), findsNothing);
    expect(find.byKey(const Key('tenant-reopen-request')), findsOneWidget);

    await tester.tap(find.byKey(const Key('tenant-reopen-request')));
    await tester.pumpAndSettle();
    expect(
      requestRepository.requests.first.status,
      ServiceRequestStatus.reopened,
    );
  });

  testWidgets('saved resident opens the dashboard', (tester) async {
    final repository = _FakeAuthRepository()
      ..resident = const Resident(
        name: 'Anna Kowalska',
        phoneNumber: '+48500000000',
        apartmentNumber: 'A-302',
      );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: const FixItApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome, Anna Kowalska'), findsOneWidget);
    expect(find.text('Apartment A-302'), findsOneWidget);
  });

  testWidgets('resident dashboard actions open their destinations', (
    tester,
  ) async {
    final repository = _FakeAuthRepository()
      ..resident = const Resident(
        name: 'Anna Kowalska',
        phoneNumber: '+48500000000',
        apartmentNumber: 'A-302',
      );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
          moveOutRepositoryProvider.overrideWithValue(_FakeMoveOutRepository()),
        ],
        child: const FixItApp(),
      ),
    );
    await tester.pumpAndSettle();

    const destinations = [
      ('create-request-action', 'Create service request'),
      ('my-requests-action', 'My requests'),
      ('history-action', 'Service history'),
      ('move-out-action', 'Move-out request'),
      ('profile-action', 'Resident profile'),
    ];

    for (final (key, title) in destinations) {
      await tester.tap(find.byKey(Key(key)));
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('service request requires a description', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _FakeAuthRepository()..resident = _demoResident,
          ),
          serviceRequestRepositoryProvider.overrideWithValue(
            _FakeServiceRequestRepository(),
          ),
        ],
        child: const FixItApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('create-request-action')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Submit request'));
    await tester.pumpAndSettle();

    expect(find.text('Add a description of the issue.'), findsOneWidget);
  });

  testWidgets('resident can submit a service request', (tester) async {
    final requestRepository = _FakeServiceRequestRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _FakeAuthRepository()..resident = _demoResident,
          ),
          serviceRequestRepositoryProvider.overrideWithValue(requestRepository),
        ],
        child: const FixItApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('create-request-action')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('request-description')),
      'Water is leaking under the kitchen sink.',
    );
    await tester.tap(find.text('Submit request'));
    await tester.pumpAndSettle();

    expect(find.text('Request FX-000001 submitted'), findsOneWidget);
    expect(requestRepository.requests, hasLength(1));
    expect(requestRepository.requests.single.category, 'Plumbing');
    expect(
      requestRepository.requests.single.description,
      'Water is leaking under the kitchen sink.',
    );
  });

  testWidgets('request details display the saved status timeline', (
    tester,
  ) async {
    final request = ServiceRequest(
      id: 'request-1',
      requestNumber: 'FX-000001',
      category: 'Plumbing',
      subcategory: 'Water leakage',
      description: 'Leak under the kitchen sink.',
      priority: ServicePriority.high,
      createdAt: DateTime(2026, 10, 17),
      status: ServiceRequestStatus.inProgress,
    );
    final requestRepository = _FakeServiceRequestRepository()
      ..requests.add(request);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _FakeAuthRepository()..resident = _demoResident,
          ),
          serviceRequestRepositoryProvider.overrideWithValue(requestRepository),
        ],
        child: const FixItApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('my-requests-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('request-request-1')));
    await tester.pumpAndSettle();

    expect(find.text('FX-000001'), findsOneWidget);
    expect(find.text('Request status'), findsOneWidget);
    expect(find.text('Submitted'), findsOneWidget);
    expect(find.text('Accepted'), findsOneWidget);
    expect(find.text('Assigned'), findsOneWidget);
    expect(find.text('Appointment scheduled'), findsOneWidget);
    expect(find.text('In progress'), findsOneWidget);
    expect(find.text('Completed'), findsNothing);
  });

  testWidgets('history filters requests and displays recorded cost', (
    tester,
  ) async {
    final requestRepository = _FakeServiceRequestRepository()
      ..requests.addAll([
        ServiceRequest(
          id: 'electrical-1',
          requestNumber: 'FX-000101',
          category: 'Electrical',
          subcategory: 'Electrical fault',
          description: 'Hallway light is out.',
          priority: ServicePriority.normal,
          createdAt: DateTime(2026, 10, 12),
          status: ServiceRequestStatus.completed,
          estimatedCost: 125.50,
        ),
        ServiceRequest(
          id: 'plumbing-1',
          requestNumber: 'FX-000102',
          category: 'Plumbing',
          subcategory: 'Water leakage',
          description: 'Leak beneath the sink.',
          priority: ServicePriority.high,
          createdAt: DateTime(2026, 10, 10),
          status: ServiceRequestStatus.submitted,
        ),
        ServiceRequest(
          id: 'electrical-2',
          requestNumber: 'FX-000103',
          category: 'Electrical',
          subcategory: 'Switch maintenance',
          description: 'Bedroom switch is loose.',
          priority: ServicePriority.low,
          createdAt: DateTime(2026, 9, 5),
          status: ServiceRequestStatus.submitted,
        ),
      ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _FakeAuthRepository()..resident = _demoResident,
          ),
          serviceRequestRepositoryProvider.overrideWithValue(requestRepository),
        ],
        child: const FixItApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('history-action')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('history-electrical-1')), findsOneWidget);
    expect(find.textContaining('Cost: 125.50'), findsOneWidget);
    expect(find.textContaining('Cost not recorded'), findsNWidgets(2));

    await tester.tap(find.byKey(const Key('history-category-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Electrical').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('history-plumbing-1')), findsNothing);
    expect(find.byKey(const Key('history-electrical-1')), findsOneWidget);

    await tester.tap(find.byKey(const Key('history-status-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Completed').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('history-electrical-1')), findsOneWidget);
    expect(find.byKey(const Key('history-electrical-2')), findsNothing);
  });

  testWidgets('profile shows tenant, apartment, tenancy and contract details', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _FakeAuthRepository()..resident = _demoResident,
          ),
        ],
        child: const FixItApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('profile-action')));
    await tester.pumpAndSettle();

    expect(find.text('Tenant details'), findsOneWidget);
    expect(find.text('Apartment details'), findsOneWidget);
    expect(find.text('Tower 3'), findsOneWidget);
    expect(find.textContaining('Dubai Marina'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Contract details'), 200);
    expect(find.text('Tenancy details'), findsOneWidget);
    expect(find.text('Contract details'), findsOneWidget);
  });

  testWidgets('closed cases show resolution details', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _FakeAuthRepository()..resident = _demoResident,
          ),
          serviceRequestRepositoryProvider.overrideWithValue(
            _FakeServiceRequestRepository(),
          ),
        ],
        child: const FixItApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('my-requests-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('closed-cases-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('closed-case-closed-1')));
    await tester.pumpAndSettle();

    expect(find.text('Approved by manager'), findsOneWidget);
    expect(find.text('Omar Haddad'), findsOneWidget);
    expect(find.text('Rashid Al Mansoori'), findsOneWidget);
    expect(find.text('Closing comments'), findsOneWidget);
  });

  testWidgets('move-out form validates and then shows progress', (
    tester,
  ) async {
    final moveOutRepository = _FakeMoveOutRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _FakeAuthRepository()..resident = _demoResident,
          ),
          moveOutRepositoryProvider.overrideWithValue(moveOutRepository),
        ],
        child: const FixItApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('move-out-action')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('moveout-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Choose a move-out date.'), findsOneWidget);
    expect(find.text('Enter a reason for moving out.'), findsOneWidget);
    expect(moveOutRepository.requests, isEmpty);

    await tester.tap(find.byKey(const Key('moveout-date')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('moveout-reason')),
      'Relocating',
    );
    await tester.enterText(
      find.byKey(const Key('moveout-address')),
      'Business Bay, Dubai',
    );
    await tester.tap(find.byKey(const Key('moveout-submit')));
    await tester.pumpAndSettle();

    expect(moveOutRepository.requests, hasLength(1));
    expect(find.text('Your move-out request'), findsOneWidget);
    expect(find.byKey(const Key('moveout-step-closed')), findsOneWidget);
  });

  testWidgets('login can switch to Arabic and applies right-to-left layout', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
        ],
        child: const FixItApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Resident sign in'), findsOneWidget);
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();

    expect(find.text('تسجيل دخول السكان'), findsOneWidget);
    expect(find.text('رقم الهاتف'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(Scaffold).first)),
      TextDirection.rtl,
    );

    await tester.tap(find.text('إرسال رمز التحقق'));
    await tester.pumpAndSettle();
    expect(find.text('أدخل رقم هاتفك.'), findsOneWidget);
  });
}

const _demoResident = Resident(
  name: 'Anna Kowalska',
  phoneNumber: '+48500000000',
  apartmentNumber: 'A-302',
);

Future<void> _signInAsTechnician(WidgetTester tester) async {
  await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Technician sign in'));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byKey(const Key('technician-id-field')),
    'TECH-001',
  );
  await tester.tap(find.byKey(const Key('technician-sign-in')));
  await tester.pumpAndSettle();
}

Future<void> _signInAsResident(WidgetTester tester) async {
  await tester.enterText(find.byKey(const Key('phone-field')), '+48 500000000');
  await tester.enterText(find.byKey(const Key('apartment-field')), 'A-302');
  await tester.tap(find.text('Send verification code'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('otp-field')), '123456');
  await tester.tap(find.text('Verify and continue'));
  await tester.pumpAndSettle();
}

class _FakeTechnicianSessionRepository implements TechnicianSessionRepository {
  String? technicianId;

  @override
  String? readTechnicianId() => technicianId;

  @override
  Future<bool> signIn(String technicianId) async {
    if (technicianId != 'TECH-001') return false;
    this.technicianId = technicianId;
    return true;
  }

  @override
  Future<void> signOut() async {
    technicianId = null;
  }
}

class _FakeAuthRepository implements AuthRepository {
  Resident? resident;
  bool _otpRequested = false;

  @override
  Resident? readSession() => resident;

  @override
  Future<bool> requestOtp({
    required String phoneNumber,
    required String apartmentNumber,
  }) async {
    _otpRequested =
        phoneNumber.replaceAll(' ', '') == '+48500000000' &&
        apartmentNumber.trim().toUpperCase() == 'A-302';
    return _otpRequested;
  }

  @override
  Future<Resident?> verifyOtp(String code) async {
    if (!_otpRequested || code != '123456') return null;
    resident = const Resident(
      name: 'Anna Kowalska',
      phoneNumber: '+48500000000',
      apartmentNumber: 'A-302',
    );
    return resident;
  }

  @override
  Future<void> signOut() async {
    resident = null;
    _otpRequested = false;
  }
}

class _FakeMoveOutRepository implements MoveOutRepository {
  final requests = <MoveOutRequest>[];

  @override
  Future<List<MoveOutRequest>> listRequests() async => List.of(requests);

  @override
  Future<MoveOutRequest> createRequest({
    required DateTime moveOutDate,
    required String reason,
    required String contactNumber,
    required String forwardingAddress,
    String notes = '',
  }) async {
    final request = MoveOutRequest(
      id: 'moveout-1',
      moveOutDate: moveOutDate,
      reason: reason,
      contactNumber: contactNumber,
      forwardingAddress: forwardingAddress,
      notes: notes,
      createdAt: DateTime(2026, 10, 18),
    );
    requests.add(request);
    return request;
  }
}

class _FakeServiceRequestRepository implements ServiceRequestRepository {
  final requests = <ServiceRequest>[];
  var _nextRequest = 0;

  @override
  Future<List<ServiceRequest>> listRequests() async => requests;

  @override
  Future<ServiceRequest> createRequest({
    required String category,
    required String subcategory,
    required String description,
    required ServicePriority priority,
    DateTime? preferredVisitAt,
    List<String> attachmentPaths = const [],
  }) async {
    _nextRequest++;
    final id = 'request-$_nextRequest';
    final request = ServiceRequest(
      id: id,
      requestNumber: 'FX-${_nextRequest.toString().padLeft(6, '0')}',
      category: category,
      subcategory: subcategory,
      description: description,
      priority: priority,
      preferredVisitAt: preferredVisitAt,
      createdAt: DateTime(2026, 10, 17),
      attachmentPaths: attachmentPaths,
    );
    requests.add(request);
    return request;
  }

  @override
  Future<void> updateRequest(ServiceRequest request) async {
    final index = requests.indexWhere((item) => item.id == request.id);
    if (index < 0) {
      requests.add(request);
    } else {
      requests[index] = request;
    }
  }
}
