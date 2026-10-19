import '../../domain/models/closed_case.dart';
import '../../domain/repositories/closed_case_repository.dart';

class MockClosedCaseRepository implements ClosedCaseRepository {
  const MockClosedCaseRepository();

  static const _technician = Technician(
    name: 'Rashid Al Mansoori',
    specialty: 'Plumbing',
    phoneNumber: '+971 50 123 4567',
  );

  @override
  Technician technicianForRequest(String requestId) => _technician;

  @override
  Future<List<ClosedCase>> listClosedCases() async => [
        ClosedCase(
          id: 'closed-1',
          requestNumber: 'FX-100231',
          category: 'Plumbing',
          subcategory: 'Water leakage',
          raisedOn: DateTime(2026, 8, 3),
          approvedBy: 'Omar Haddad',
          technician: _technician,
          appointmentAt: DateTime(2026, 8, 5, 10),
          fixedOn: DateTime(2026, 8, 5),
          closingComments: 'Replaced the damaged kitchen sink pipe joint. '
              'No further leakage observed.',
        ),
        ClosedCase(
          id: 'closed-2',
          requestNumber: 'FX-100187',
          category: 'Electrical',
          subcategory: 'Switch maintenance',
          raisedOn: DateTime(2026, 6, 14),
          approvedBy: 'Layla Nasser',
          technician: const Technician(
            name: 'Imran Qureshi',
            specialty: 'Electrical',
            phoneNumber: '+971 55 987 6543',
          ),
          appointmentAt: DateTime(2026, 6, 16, 14, 30),
          fixedOn: DateTime(2026, 6, 16),
          closingComments: 'Faulty living room switch replaced and tested.',
        ),
      ];
}
