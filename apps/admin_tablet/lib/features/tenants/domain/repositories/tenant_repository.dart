import '../models/tenant_records.dart';

abstract interface class TenantRepository {
  List<TenantRecord> get tenants;
  List<TenancyRecord> get tenancies;

  void addTenant({
    required TenantRecord tenant,
    required TenancyRecord tenancy,
  });

  void setTenantStatus(String tenantId, TenantStatus status);
}
