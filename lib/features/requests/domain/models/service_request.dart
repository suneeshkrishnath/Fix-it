enum ServicePriority { low, normal, high }

enum ServiceRequestStatus {
  submitted,
  accepted,
  assigned,
  appointmentScheduled,
  inProgress,
  completed,
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
    );
  }
}