enum NotificationAudience { tenant, technician, administrator }

enum NotificationEvent {
  workAccepted,
  workRejected,
  travellingToSite,
  workStarted,
  workBlocked,
  workCompleted,
  tenantAccepted,
  tenantRejected,
  administratorApproved,
  workOrderClosed,
  reopened,
  technicianAssigned,
  appointmentProposalApproved,
}

class DemoNotification {
  const DemoNotification({
    required this.id,
    required this.audience,
    required this.event,
    required this.requestNumber,
    required this.occurredAt,
    this.technicianName,
    this.reason,
    this.elapsedMinutes,
  });

  final String id;
  final NotificationAudience audience;
  final NotificationEvent event;
  final String requestNumber;
  final DateTime occurredAt;
  final String? technicianName;
  final String? reason;
  final int? elapsedMinutes;
}
