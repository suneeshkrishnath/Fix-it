import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fix_it/app/app.dart';
import 'package:fix_it/features/auth/domain/models/resident.dart';
import 'package:fix_it/features/auth/domain/repositories/auth_repository.dart';
import 'package:fix_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:fix_it/features/requests/domain/models/service_request.dart';
import 'package:fix_it/features/requests/domain/repositories/service_request_repository.dart';
import 'package:fix_it/features/requests/presentation/providers/service_request_providers.dart';

void main() {
  testWidgets('resident can request and verify a mock OTP', (tester) async {
    final repository = _FakeAuthRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: const FixItApp(),
      ),
    );

    await tester.enterText(find.byKey(const Key('phone-field')), '+48 500000000');
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

    await tester.enterText(find.byKey(const Key('phone-field')), '+48 111111111');
    await tester.enterText(find.byKey(const Key('apartment-field')), 'B-404');
    await tester.tap(find.text('Send verification code'));
    await tester.pumpAndSettle();

    expect(find.text('Resident details were not recognized.'), findsOneWidget);
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

  testWidgets('resident dashboard actions open their destinations',
      (tester) async {
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
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()
            ..resident = _demoResident),
          serviceRequestRepositoryProvider
              .overrideWithValue(_FakeServiceRequestRepository()),
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
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()
            ..resident = _demoResident),
          serviceRequestRepositoryProvider
              .overrideWithValue(requestRepository),
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
    expect(requestRepository.requests.single.description,
        'Water is leaking under the kitchen sink.');
  });
}

const _demoResident = Resident(
  name: 'Anna Kowalska',
  phoneNumber: '+48500000000',
  apartmentNumber: 'A-302',
);

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
    _otpRequested = phoneNumber.replaceAll(' ', '') == '+48500000000' &&
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

class _FakeServiceRequestRepository implements ServiceRequestRepository {
  final requests = <ServiceRequest>[];

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
    final request = ServiceRequest(
      id: 'request-1',
      requestNumber: 'FX-000001',
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
  Future<void> updateRequest(ServiceRequest request) async {}
}
