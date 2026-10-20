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
  final String? assignedTechnicianId;
  final String? assignedTechnicianName;
  final List<AdminRequestEvent> history;

  AdminRequestRecord copyWith({
    WorkRequestStatus? status,
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
    assignedTechnicianId: assignedTechnicianId ?? this.assignedTechnicianId,
    assignedTechnicianName:
        assignedTechnicianName ?? this.assignedTechnicianName,
    history: history ?? this.history,
  );
}
