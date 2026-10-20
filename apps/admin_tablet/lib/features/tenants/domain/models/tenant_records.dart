enum TenantStatus { active, inactive }

enum TenancyStatus { active, scheduled, ended }

class TenantRecord {
  const TenantRecord({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    this.status = TenantStatus.active,
  });

  final String id;
  final String fullName;
  final String phone;
  final String email;
  final TenantStatus status;

  TenantRecord copyWith({
    String? fullName,
    String? phone,
    String? email,
    TenantStatus? status,
  }) => TenantRecord(
    id: id,
    fullName: fullName ?? this.fullName,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    status: status ?? this.status,
  );
}

class TenancyRecord {
  const TenancyRecord({
    required this.id,
    required this.tenantId,
    required this.apartmentId,
    required this.startDate,
    required this.endDate,
    this.status = TenancyStatus.active,
    this.agreementDocumentName,
  });

  final String id;
  final String tenantId;
  final String apartmentId;
  final DateTime startDate;
  final DateTime endDate;
  final TenancyStatus status;
  final String? agreementDocumentName;
}
