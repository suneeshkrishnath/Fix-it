import '../../../auth/domain/models/resident.dart';
import '../../domain/models/resident_profile.dart';
import '../../domain/repositories/resident_profile_repository.dart';

class MockResidentProfileRepository implements ResidentProfileRepository {
  const MockResidentProfileRepository();

  @override
  Future<ResidentProfile> loadProfile(Resident resident) async =>
      ResidentProfile(
        tenantName: resident.name,
        phoneNumber: resident.phoneNumber,
        email: 'anna.kowalska@example.com',
        emiratesId: '784-****-*******-1',
        apartmentNumber: resident.apartmentNumber,
        towerNumber: 'Tower 3',
        floor: '3',
        address: 'Marina Promenade, Dubai Marina, Dubai, UAE',
        tenancyStart: DateTime(2026, 1, 1),
        tenancyEnd: DateTime(2026, 12, 31),
        annualRent: 'AED 95,000',
        paymentFrequency: 'Quarterly',
        securityDeposit: 'AED 4,750',
        contractNumber: 'EJARI-2026-004521',
        landlord: 'Marina Heights Property Management',
        contractIssuedOn: DateTime(2025, 12, 20),
        contractExpiresOn: DateTime(2026, 12, 31),
      );
}
