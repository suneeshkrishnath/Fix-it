enum WorkRequestStatus {
  submitted,
  informationRequested,
  readyToAssign,
  assigned,
  rejected,
}

extension WorkRequestStatusLabel on WorkRequestStatus {
  String get label => switch (this) {
    WorkRequestStatus.submitted => 'Submitted',
    WorkRequestStatus.informationRequested => 'Information requested',
    WorkRequestStatus.readyToAssign => 'Ready to assign',
    WorkRequestStatus.assigned => 'Assigned',
    WorkRequestStatus.rejected => 'Rejected',
  };
}

class AdminRequestEvent {
  const AdminRequestEvent({
    required this.label,
    required this.actor,
    required this.occurredAt,
    this.reason,
    this.technicianName,
  });

  final String label;
  final String actor;
  final DateTime occurredAt;
  final String? reason;
  final String? technicianName;
}

enum AppointmentDecision { pending, approved, rejected }

class AppointmentProposal {
  const AppointmentProposal({
    required this.proposedAt,
    required this.reason,
    this.tenantDecision = AppointmentDecision.pending,
    this.adminDecision = AppointmentDecision.pending,
    this.tenantDecisionAt,
    this.adminDecisionAt,
  });

  final DateTime proposedAt;
  final String reason;
  final AppointmentDecision tenantDecision;
  final AppointmentDecision adminDecision;
  final DateTime? tenantDecisionAt;
  final DateTime? adminDecisionAt;

  AppointmentProposal copyWith({
    AppointmentDecision? tenantDecision,
    AppointmentDecision? adminDecision,
    DateTime? tenantDecisionAt,
    DateTime? adminDecisionAt,
  }) => AppointmentProposal(
    proposedAt: proposedAt,
    reason: reason,
    tenantDecision: tenantDecision ?? this.tenantDecision,
    adminDecision: adminDecision ?? this.adminDecision,
    tenantDecisionAt: tenantDecisionAt ?? this.tenantDecisionAt,
    adminDecisionAt: adminDecisionAt ?? this.adminDecisionAt,
  );
}

class AdminRequestRecord {
  const AdminRequestRecord({
    required this.id,
    required this.requestNumber,
    required this.tenantName,
    required this.apartment,
    required this.building,
    required this.category,
    required this.description,
    required this.priority,
    required this.createdAt,
    required this.status,
    required this.history,
    this.scheduledAt,
    this.appointmentProposal,
    this.assignedTechnicianId,
    this.assignedTechnicianName,
  });

  final String id;
  final String requestNumber;
  final String tenantName;
  final String apartment;
  final String building;
  final String category;
  final String description;
  final String priority;
  final DateTime createdAt;
  final WorkRequestStatus status;
  final DateTime? scheduledAt;
  final AppointmentProposal? appointmentProposal;
  final String? assignedTechnicianId;
  final String? assignedTechnicianName;
  final List<AdminRequestEvent> history;

  AdminRequestRecord copyWith({
    WorkRequestStatus? status,
    DateTime? scheduledAt,
    AppointmentProposal? appointmentProposal,
    String? assignedTechnicianId,
    String? assignedTechnicianName,
    List<AdminRequestEvent>? history,
  }) => AdminRequestRecord(
    id: id,
    requestNumber: requestNumber,
    tenantName: tenantName,
    apartment: apartment,
    building: building,
    category: category,
    description: description,
    priority: priority,
    createdAt: createdAt,
    status: status ?? this.status,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    appointmentProposal: appointmentProposal ?? this.appointmentProposal,
    assignedTechnicianId: assignedTechnicianId ?? this.assignedTechnicianId,
    assignedTechnicianName:
        assignedTechnicianName ?? this.assignedTechnicianName,
    history: history ?? this.history,
  );
}
