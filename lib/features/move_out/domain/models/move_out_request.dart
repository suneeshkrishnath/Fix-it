enum MoveOutStatus {
  submitted,
  review,
  inspectionScheduled,
  inspectionCompleted,
  approved,
  closed,
}

class MoveOutRequest {
  const MoveOutRequest({
    required this.id,
    required this.moveOutDate,
    required this.reason,
    required this.contactNumber,
    required this.forwardingAddress,
    required this.createdAt,
    this.notes = '',
    this.status = MoveOutStatus.submitted,
  });

  final String id;
  final DateTime moveOutDate;
  final String reason;
  final String contactNumber;
  final String forwardingAddress;
  final String notes;
  final DateTime createdAt;
  final MoveOutStatus status;

  Map<String, Object> toMap() => {
        'id': id,
        'moveOutDate': moveOutDate.toIso8601String(),
        'reason': reason,
        'contactNumber': contactNumber,
        'forwardingAddress': forwardingAddress,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
        'status': status.name,
      };

  factory MoveOutRequest.fromMap(Map<dynamic, dynamic> map) => MoveOutRequest(
        id: map['id'] as String,
        moveOutDate: DateTime.parse(map['moveOutDate'] as String),
        reason: map['reason'] as String,
        contactNumber: map['contactNumber'] as String,
        forwardingAddress: map['forwardingAddress'] as String,
        notes: map['notes'] as String? ?? '',
        createdAt: DateTime.parse(map['createdAt'] as String),
        status: MoveOutStatus.values.firstWhere(
          (value) => value.name == map['status'],
          orElse: () => MoveOutStatus.submitted,
        ),
      );
}
