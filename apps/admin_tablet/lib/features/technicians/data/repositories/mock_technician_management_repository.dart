import 'package:flutter/foundation.dart';

import '../../domain/models/technician_records.dart';

class MockTechnicianManagementRepository extends ChangeNotifier {
  final List<TechnicianRecord> _technicians = [
    const TechnicianRecord(
      id: 'tech-rashid',
      loginId: 'TECH-001',
      fullName: 'Rashid Al Mansoori',
      phone: '+971 50 123 4567',
      specialty: 'Plumbing',
      roleId: 'role-technician',
      availability: TechnicianAvailability.available,
    ),
    const TechnicianRecord(
      id: 'tech-imran',
      loginId: 'TECH-002',
      fullName: 'Imran Qureshi',
      phone: '+971 55 987 6543',
      specialty: 'Electrical',
      roleId: 'role-technician',
      availability: TechnicianAvailability.onJob,
    ),
  ];

  final List<AdminRoleRecord> _roles = [
    const AdminRoleRecord(
      id: 'role-technician',
      name: 'Technician',
      permissions: {
        'View assigned work orders',
        'Update assigned work status',
        'Propose appointment changes',
        'View apartment location and access notes',
      },
    ),
    const AdminRoleRecord(
      id: 'role-administrator',
      name: 'Administrator',
      permissions: {
        'Manage property hierarchy',
        'Manage tenant and tenancy records',
        'Manage technician accounts and roles',
        'Review and assign work orders',
        'Approve appointment changes',
        'Approve work completion and closure',
        'View operational reports',
      },
    ),
  ];

  int _nextId = 1;

  List<TechnicianRecord> get technicians => List.unmodifiable(_technicians);
  List<AdminRoleRecord> get roles => List.unmodifiable(_roles);

  String nextId(String prefix) => '$prefix-${_nextId++}';

  void saveTechnician(TechnicianRecord record) {
    final index = _technicians.indexWhere((item) => item.id == record.id);
    if (index == -1) {
      _technicians.add(record);
    } else {
      _technicians[index] = record;
    }
    notifyListeners();
  }

  void setTechnicianStatus(String id, AccountStatus status) {
    final index = _technicians.indexWhere((item) => item.id == id);
    if (index < 0) return;
    _technicians[index] = _technicians[index].copyWith(status: status);
    notifyListeners();
  }

  void saveRole(AdminRoleRecord role) {
    final index = _roles.indexWhere((item) => item.id == role.id);
    if (index == -1) {
      _roles.add(role);
    } else {
      _roles[index] = role;
    }
    notifyListeners();
  }
}
