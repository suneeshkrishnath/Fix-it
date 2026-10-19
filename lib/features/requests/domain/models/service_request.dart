enum ServicePriority { low, normal, high }

enum ServiceRequestStatus {
  submitted,
  accepted,
  assigned,
  appointmentScheduled,
  inProgress,
  completed,
  awaitingTenantConfirmation,
  closed,
  reopened,
  rejected,
  cancelled,
}

class ServiceRequest {
  const ServiceRequest({
    required this.id,
    required this.requestNumber,
    required this.category,
    required this.subcategory,
    required this.description,
    required this.priority,
    required this.createdAt,
    this.preferredVisitAt,
    this.status = ServiceRequestStatus.submitted,
    this.estimatedCost,
    this.attachmentPaths = const [],
    this.assignedTechnicianId,
    this.technicianName,
    this.location,
    this.appointmentAt,
    this.completionComments,
    this.awaitingTenantConfirmation = false,
    this.proposedAppointmentAt,
    this.tenantApprovedAppointmentChange = false,
    this.adminApprovedAppointmentChange = false,
    this.closedAt,
    this.reopenedAt,
    this.isSample = false,
  });

  final String id;
  final String requestNumber;
  final String category;
  final String subcategory;
  final String description;
  final ServicePriority priority;
  final DateTime createdAt;
  final DateTime? preferredVisitAt;
  final ServiceRequestStatus status;
  final double? estimatedCost;
  final List<String> attachmentPaths;
  final String? assignedTechnicianId;
  final String? technicianName;
  final String? location;
  final DateTime? appointmentAt;
  final String? completionComments;
  final bool awaitingTenantConfirmation;
  final DateTime? proposedAppointmentAt;
  final bool tenantApprovedAppointmentChange;
  final bool adminApprovedAppointmentChange;
  final DateTime? closedAt;
  final DateTime? reopenedAt;
  final bool isSample;

  ServiceRequest copyWith({
    ServiceRequestStatus? status,
    String? assignedTechnicianId,
    String? technicianName,
    String? location,
    DateTime? appointmentAt,
    String? completionComments,
    bool? awaitingTenantConfirmation,
    DateTime? proposedAppointmentAt,
    bool? tenantApprovedAppointmentChange,
    bool? adminApprovedAppointmentChange,
    DateTime? closedAt,
    DateTime? reopenedAt,
    bool? isSample,
    bool clearProposedAppointment = false,
    bool clearClosedAt = false,
  }) => ServiceRequest(
    id: id,
    requestNumber: requestNumber,
    category: category,
    subcategory: subcategory,
    description: description,
    priority: priority,
    createdAt: createdAt,
    preferredVisitAt: preferredVisitAt,
    status: status ?? this.status,
    estimatedCost: estimatedCost,
    attachmentPaths: attachmentPaths,
    assignedTechnicianId: assignedTechnicianId ?? this.assignedTechnicianId,
    technicianName: technicianName ?? this.technicianName,
    location: location ?? this.location,
    appointmentAt: appointmentAt ?? this.appointmentAt,
    completionComments: completionComments ?? this.completionComments,
    awaitingTenantConfirmation:
        awaitingTenantConfirmation ?? this.awaitingTenantConfirmation,
    proposedAppointmentAt: clearProposedAppointment
        ? null
        : proposedAppointmentAt ?? this.proposedAppointmentAt,
    tenantApprovedAppointmentChange: clearProposedAppointment
        ? false
        : tenantApprovedAppointmentChange ??
              this.tenantApprovedAppointmentChange,
    adminApprovedAppointmentChange: clearProposedAppointment
        ? false
        : adminApprovedAppointmentChange ?? this.adminApprovedAppointmentChange,
    closedAt: clearClosedAt ? null : closedAt ?? this.closedAt,
    reopenedAt: reopenedAt ?? this.reopenedAt,
    isSample: isSample ?? this.isSample,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'requestNumber': requestNumber,
    'category': category,
    'subcategory': subcategory,
    'description': description,
    'priority': priority.name,
    'createdAt': createdAt.toIso8601String(),
    'preferredVisitAt': preferredVisitAt?.toIso8601String(),
    'status': status.name,
    'estimatedCost': estimatedCost,
    'attachmentPaths': attachmentPaths,
    'assignedTechnicianId': assignedTechnicianId,
    'technicianName': technicianName,
    'location': location,
    'appointmentAt': appointmentAt?.toIso8601String(),
    'completionComments': completionComments,
    'awaitingTenantConfirmation': awaitingTenantConfirmation,
    'proposedAppointmentAt': proposedAppointmentAt?.toIso8601String(),
    'tenantApprovedAppointmentChange': tenantApprovedAppointmentChange,
    'adminApprovedAppointmentChange': adminApprovedAppointmentChange,
    'closedAt': closedAt?.toIso8601String(),
    'reopenedAt': reopenedAt?.toIso8601String(),
    'isSample': isSample,
  };

  factory ServiceRequest.fromMap(Map<dynamic, dynamic> map) {
    final statusName = map['status'] as String?;
    final priorityName = map['priority'] as String?;
    return ServiceRequest(
      id: map['id'] as String,
      requestNumber: map['requestNumber'] as String,
      category: map['category'] as String,
      subcategory: map['subcategory'] as String,
      description: map['description'] as String,
      priority: ServicePriority.values.firstWhere(
        (value) => value.name == priorityName,
        orElse: () => ServicePriority.normal,
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
      preferredVisitAt: map['preferredVisitAt'] == null
          ? null
          : DateTime.parse(map['preferredVisitAt'] as String),
      status: ServiceRequestStatus.values.firstWhere(
        (value) => value.name == statusName,
        orElse: () => ServiceRequestStatus.submitted,
      ),
      estimatedCost: (map['estimatedCost'] as num?)?.toDouble(),
      attachmentPaths: (map['attachmentPaths'] as List<dynamic>? ?? [])
          .cast<String>(),
      assignedTechnicianId: map['assignedTechnicianId'] as String?,
      technicianName: map['technicianName'] as String?,
      location: map['location'] as String?,
      appointmentAt: map['appointmentAt'] == null
          ? null
          : DateTime.parse(map['appointmentAt'] as String),
      completionComments: map['completionComments'] as String?,
      awaitingTenantConfirmation:
          map['awaitingTenantConfirmation'] as bool? ?? false,
      proposedAppointmentAt: map['proposedAppointmentAt'] == null
          ? null
          : DateTime.parse(map['proposedAppointmentAt'] as String),
      tenantApprovedAppointmentChange:
          map['tenantApprovedAppointmentChange'] as bool? ?? false,
      adminApprovedAppointmentChange:
          map['adminApprovedAppointmentChange'] as bool? ?? false,
      closedAt: map['closedAt'] == null
          ? null
          : DateTime.parse(map['closedAt'] as String),
      reopenedAt: map['reopenedAt'] == null
          ? null
          : DateTime.parse(map['reopenedAt'] as String),
      isSample: map['isSample'] as bool? ?? false,
    );
  }
}
