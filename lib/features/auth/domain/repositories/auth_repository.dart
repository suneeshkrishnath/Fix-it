import '../models/resident.dart';

abstract interface class AuthRepository {
  Resident? readSession();

  Future<bool> requestOtp({
    required String phoneNumber,
    required String apartmentNumber,
  });

  Future<Resident?> verifyOtp(String code);

  Future<void> signOut();
}