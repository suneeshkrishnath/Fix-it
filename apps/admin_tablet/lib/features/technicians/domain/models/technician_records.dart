enum TechnicianAvailability { available, onJob, offDuty }

enum AccountStatus { active, inactive }

const technicianPermissionCatalog = [
  'View assigned work orders',
  'Update assigned work status',
  'Propose appointment changes',
  'View apartment location and access notes',
  'Manage property hierarchy',
  'Manage tenant and tenancy records',
  'Manage technician accounts and roles',
  'Review and assign work orders',
  'Approve appointment changes',
  'Approve work completion and closure',
  'View operational reports',
];

class AdminRoleRecord {
  const AdminRoleRecord({
    required this.id,
    required this.name,
    required this.permissions,
  });

  final String id;
  final String name;
  final Set<String> permissions;
}

class TechnicianRecord {
  const TechnicianRecord({
    required this.id,
    required this.loginId,
    required this.fullName,
    required this.phone,
    required this.specialty,
    required this.roleId,
    this.availability = TechnicianAvailability.available,
    this.status = AccountStatus.active,
  });

  final String id;
  final String loginId;
  final String fullName;
  final String phone;
  final String specialty;
  final String roleId;
  final TechnicianAvailability availability;
  final AccountStatus status;

  TechnicianRecord copyWith({
    String? loginId,
    String? fullName,
    String? phone,
    String? specialty,
    String? roleId,
    TechnicianAvailability? availability,
    AccountStatus? status,
  }) => TechnicianRecord(
    id: id,
    loginId: loginId ?? this.loginId,
    fullName: fullName ?? this.fullName,
    phone: phone ?? this.phone,
    specialty: specialty ?? this.specialty,
    roleId: roleId ?? this.roleId,
    availability: availability ?? this.availability,
    status: status ?? this.status,
  );
}
