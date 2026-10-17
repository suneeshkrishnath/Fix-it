import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fix_it/app/app.dart';
import 'package:fix_it/features/auth/domain/models/resident.dart';
import 'package:fix_it/features/auth/domain/repositories/auth_repository.dart';
import 'package:fix_it/features/auth/presentation/providers/auth_providers.dart';

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
