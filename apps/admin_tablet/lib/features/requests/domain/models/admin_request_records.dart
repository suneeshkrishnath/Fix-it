enum WorkRequestStatus {
  submitted,
  informationRequested,
  readyToAssign,
  assigned,
  travelling,
  workStarted,
  workBlocked,
  awaitingTenantConfirmation,
  awaitingAdminClosureApproval,
  closed,
  reopenPendingReview,
  reopened,
  rejected,
}

extension WorkRequestStatusLabel on WorkRequestStatus {
  String get label => switch (this) {
    WorkRequestStatus.submitted => 'Submitted',
    WorkRequestStatus.informationRequested => 'Information requested',
    WorkRequestStatus.readyToAssign => 'Ready to assign',
    WorkRequestStatus.assigned => 'Assigned',
    WorkRequestStatus.travelling => 'Travelling to site',
    WorkRequestStatus.workStarted => 'Work started',
    WorkRequestStatus.workBlocked => 'Work blocked',
    WorkRequestStatus.awaitingTenantConfirmation =>
      'Awaiting tenant confirmation',
    WorkRequestStatus.awaitingAdminClosureApproval =>
      'Awaiting admin closure approval',
    WorkRequestStatus.closed => 'Closed',
    WorkRequestStatus.reopenPendingReview => 'Reopen pending review',
    WorkRequestStatus.reopened => 'Reopened',
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

enum CompletionDecision { pending, accepted, rejected }

class WorkCompletionRecord {
  const WorkCompletionRecord({
    required this.workStartedAt,
    required this.completedAt,
    required this.elapsedWorkMinutes,
    required this.comments,
    this.tenantDecision = CompletionDecision.pending,
    this.tenantDecisionAt,
    this.tenantReason,
    this.adminApprovedAt,
  });

  final DateTime workStartedAt;
  final DateTime completedAt;
  final int elapsedWorkMinutes;
  final String comments;
  final CompletionDecision tenantDecision;
  final DateTime? tenantDecisionAt;
  final String? tenantReason;
  final DateTime? adminApprovedAt;

  WorkCompletionRecord copyWith({
    CompletionDecision? tenantDecision,
    DateTime? tenantDecisionAt,
    String? tenantReason,
    DateTime? adminApprovedAt,
  }) => WorkCompletionRecord(
    workStartedAt: workStartedAt,
    completedAt: completedAt,
    elapsedWorkMinutes: elapsedWorkMinutes,
    comments: comments,
    tenantDecision: tenantDecision ?? this.tenantDecision,
    tenantDecisionAt: tenantDecisionAt ?? this.tenantDecisionAt,
    tenantReason: tenantReason ?? this.tenantReason,
    adminApprovedAt: adminApprovedAt ?? this.adminApprovedAt,
  );
}

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
    this.travellingAt,
    this.workStartedAt,
    this.blockedAt,
    this.resumedAt,
    this.blockReason,
    this.closedAt,
    this.reopenRequestedAt,
    this.reopenReason,
    this.completions = const [],
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
  final DateTime? travellingAt;
  final DateTime? workStartedAt;
  final DateTime? blockedAt;
  final DateTime? resumedAt;
  final String? blockReason;
  final DateTime? closedAt;
  final DateTime? reopenRequestedAt;
  final String? reopenReason;
  final List<WorkCompletionRecord> completions;
  final String? assignedTechnicianId;
  final String? assignedTechnicianName;
  final List<AdminRequestEvent> history;

  AdminRequestRecord copyWith({
    WorkRequestStatus? status,
    DateTime? scheduledAt,
    AppointmentProposal? appointmentProposal,
    DateTime? travellingAt,
    DateTime? workStartedAt,
    DateTime? blockedAt,
    DateTime? resumedAt,
    String? blockReason,
    DateTime? closedAt,
    DateTime? reopenRequestedAt,
    String? reopenReason,
    List<WorkCompletionRecord>? completions,
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
    travellingAt: travellingAt ?? this.travellingAt,
    workStartedAt: workStartedAt ?? this.workStartedAt,
    blockedAt: blockedAt ?? this.blockedAt,
    resumedAt: resumedAt ?? this.resumedAt,
    blockReason: blockReason ?? this.blockReason,
    closedAt: closedAt ?? this.closedAt,
    reopenRequestedAt: reopenRequestedAt ?? this.reopenRequestedAt,
    reopenReason: reopenReason ?? this.reopenReason,
    completions: completions ?? this.completions,
    assignedTechnicianId: assignedTechnicianId ?? this.assignedTechnicianId,
    assignedTechnicianName:
        assignedTechnicianName ?? this.assignedTechnicianName,
    history: history ?? this.history,
  );
}
