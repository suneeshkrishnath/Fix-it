enum TechnicianWorkflowStatus {
  workAccepted,
  workRejected,
  travellingToSite,
  workStarted,
  workBlocked,
  workCompletedAwaitingConfirmation,
  closed,
  reopened,
}

class TechnicianWorkflowSample {
  const TechnicianWorkflowSample({
    required this.requestNumber,
    required this.status,
    required this.technicianName,
    required this.happenedAt,
    this.reason,
    this.elapsedMinutes,
  });

  final String requestNumber;
  final TechnicianWorkflowStatus status;
  final String technicianName;
  final DateTime happenedAt;
  final String? reason;
  final int? elapsedMinutes;
}
