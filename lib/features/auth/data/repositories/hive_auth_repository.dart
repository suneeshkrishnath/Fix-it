import 'package:hive/hive.dart';

import '../../domain/models/resident.dart';
import '../../domain/repositories/auth_repository.dart';

class HiveAuthRepository implements AuthRepository {
  HiveAuthRepository(this._box);

  static const demoOtp = '123456';
  static const _demoPhone = '+48500000000';
  static const _demoApartment = 'A-302';
  static const _sessionKey = 'resident';

  final Box<dynamic> _box;
  String? _pendingPhone;
  String? _pendingApartment;

  @override
  Resident? readSession() {
    final saved = _box.get(_sessionKey);
    if (saved is Map) return Resident.fromMap(saved);
    return null;
  }

  @override
  Future<bool> requestOtp({
    required String phoneNumber,
    required String apartmentNumber,
  }) async {
    final normalizedPhone = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    final normalizedApartment = apartmentNumber.trim().toUpperCase();
    if (normalizedPhone != _demoPhone ||
        normalizedApartment != _demoApartment) {
      return false;
    }

    _pendingPhone = normalizedPhone;
    _pendingApartment = normalizedApartment;
    return true;
  }

  @override
  Future<Resident?> verifyOtp(String code) async {
    if (code != demoOtp || _pendingPhone == null || _pendingApartment == null) {
      return null;
    }

    final resident = Resident(
      name: 'Anna Kowalska',
      phoneNumber: _pendingPhone!,
      apartmentNumber: _pendingApartment!,
    );
    await _box.put(_sessionKey, resident.toMap());
    _pendingPhone = null;
    _pendingApartment = null;
    return resident;
  }

  @override
  Future<void> signOut() async {
    await _box.delete(_sessionKey);
    _pendingPhone = null;
    _pendingApartment = null;
  }
}