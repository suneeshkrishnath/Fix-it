import 'package:flutter/foundation.dart';

import '../../domain/models/tenant_records.dart';
import '../../domain/repositories/tenant_repository.dart';

class MockTenantRepository extends ChangeNotifier implements TenantRepository {
  final List<TenantRecord> _tenants = [
    const TenantRecord(
      id: 'tenant-anna',
      fullName: 'Anna Kowalska',
      phone: '+971 50 123 4567',
      email: 'anna.kowalska@example.test',
    ),
    const TenantRecord(
      id: 'tenant-omar',
      fullName: 'Omar Haddad',
      phone: '+971 55 234 5678',
      email: 'omar.haddad@example.test',
    ),
  ];

  final List<TenancyRecord> _tenancies = [
    TenancyRecord(
      id: 'tenancy-anna',
      tenantId: 'tenant-anna',
      apartmentId: 'apt-a302',
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 12, 31),
    ),
    TenancyRecord(
      id: 'tenancy-omar',
      tenantId: 'tenant-omar',
      apartmentId: 'apt-ba12',
      startDate: DateTime(2026, 3, 1),
      endDate: DateTime(2027, 2, 28),
    ),
  ];

  int _nextId = 1;

  @override
  List<TenantRecord> get tenants => List.unmodifiable(_tenants);

  @override
  List<TenancyRecord> get tenancies => List.unmodifiable(_tenancies);

  String nextId(String prefix) => '$prefix-${_nextId++}';

  @override
  void addTenant({
    required TenantRecord tenant,
    required TenancyRecord tenancy,
  }) {
    _tenants.add(tenant);
    _tenancies.add(tenancy);
    notifyListeners();
  }

  @override
  void setTenantStatus(String tenantId, TenantStatus status) {
    final index = _tenants.indexWhere((tenant) => tenant.id == tenantId);
    if (index < 0) return;
    _tenants[index] = _tenants[index].copyWith(status: status);
    notifyListeners();
  }
}
