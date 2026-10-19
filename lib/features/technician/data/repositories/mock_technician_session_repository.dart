import 'package:hive/hive.dart';

import '../../domain/repositories/technician_session_repository.dart';

class MockTechnicianSessionRepository implements TechnicianSessionRepository {
  MockTechnicianSessionRepository(this._box);

  static const demoTechnicianId = 'TECH-001';
  static const _sessionKey = 'technician_id';
  static String? _memorySession;

  final Box<dynamic>? _box;

  @override
  String? readTechnicianId() =>
      _box?.get(_sessionKey) as String? ?? _memorySession;

  @override
  Future<bool> signIn(String technicianId) async {
    if (technicianId.trim().toUpperCase() != demoTechnicianId) return false;
    _memorySession = demoTechnicianId;
    await _box?.put(_sessionKey, demoTechnicianId);
    return true;
  }

  @override
  Future<void> signOut() async {
    _memorySession = null;
    await _box?.delete(_sessionKey);
  }
}
