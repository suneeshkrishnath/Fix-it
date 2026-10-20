import 'package:flutter/foundation.dart';

import '../../domain/models/admin_request_records.dart';

class MockAdminRequestRepository extends ChangeNotifier {
  MockAdminRequestRepository()
    : _requests = [
        _seedRequest(
          id: 'request-1042',
          number: 'REQ-1042',
          tenant: 'Mariam Hassan',
          apartment: 'A-302',
          building: 'Marina Tower 1',
          category: 'Plumbing',
          description: 'Water is leaking under the kitchen sink.',
          priority: 'High',
          status: WorkRequestStatus.submitted,
          createdAt: DateTime(2026, 10, 20, 8, 42),
        ),
        _seedRequest(
          id: 'request-1041',
          number: 'REQ-1041',
          tenant: 'Omar Farouk',
          apartment: 'A-205',
          building: 'Marina Tower 1',
          category: 'Electrical',
          description: 'The bedroom wall socket is not working.',
          priority: 'Normal',
          status: WorkRequestStatus.readyToAssign,
          createdAt: DateTime(2026, 10, 20, 8, 5),
          history: [
            AdminRequestEvent(
              label: 'Request submitted',
              actor: 'Resident',
              occurredAt: DateTime(2026, 10, 20, 8, 5),
            ),
            AdminRequestEvent(
              label: 'Approved for assignment',
              actor: 'Admin',
              occurredAt: DateTime(2026, 10, 20, 8, 20),
              reason: 'Request details verified.',
            ),
          ],
        ),
        _seedRequest(
          id: 'request-1038',
          number: 'REQ-1038',
          tenant: 'Noor Ahmed',
          apartment: 'A-114',
          building: 'Marina Tower 2',
          category: 'Air conditioning',
          description: 'The living room AC is not cooling.',
          priority: 'Urgent',
          status: WorkRequestStatus.assigned,
          createdAt: DateTime(2026, 10, 19, 16, 35),
          technicianId: 'tech-imran',
          technicianName: 'Imran Qureshi',
          history: [
            AdminRequestEvent(
              label: 'Request submitted',
              actor: 'Resident',
              occurredAt: DateTime(2026, 10, 19, 16, 35),
            ),
            AdminRequestEvent(
              label: 'Approved for assignment',
              actor: 'Admin',
              occurredAt: DateTime(2026, 10, 19, 16, 50),
              reason: 'Urgent cooling issue.',
            ),
            AdminRequestEvent(
              label: 'Assigned to technician',
              actor: 'Admin',
              occurredAt: DateTime(2026, 10, 19, 17, 0),
              technicianName: 'Imran Qureshi',
            ),
          ],
        ),
        _seedRequest(
          id: 'request-1035',
          number: 'REQ-1035',
          tenant: 'Ali Rahman',
          apartment: 'B-410',
          building: 'Marina Tower 3',
          category: 'Maintenance',
          description: 'Please share a photo of the damaged cabinet hinge.',
          priority: 'Low',
          status: WorkRequestStatus.informationRequested,
          createdAt: DateTime(2026, 10, 19, 14, 10),
          history: [
            AdminRequestEvent(
              label: 'Request submitted',
              actor: 'Resident',
              occurredAt: DateTime(2026, 10, 19, 14, 10),
            ),
            AdminRequestEvent(
              label: 'Information requested',
              actor: 'Admin',
              occurredAt: DateTime(2026, 10, 19, 14, 30),
              reason: 'Please share a photo of the damaged cabinet hinge.',
            ),
          ],
        ),
      ];

  final List<AdminRequestRecord> _requests;

  List<AdminRequestRecord> get requests => List.unmodifiable(_requests);

  void recordDecision({
    required String requestId,
    required WorkRequestStatus status,
    required String reason,
  }) {
    if (status != WorkRequestStatus.informationRequested &&
        status != WorkRequestStatus.readyToAssign &&
        status != WorkRequestStatus.rejected) {
      throw ArgumentError.value(status, 'status', 'Not a review decision');
    }
    _updateRequest(
      requestId,
      (request) => request.copyWith(
        status: status,
        history: [
          ...request.history,
          AdminRequestEvent(
            label: switch (status) {
              WorkRequestStatus.informationRequested => 'Information requested',
              WorkRequestStatus.readyToAssign => 'Approved for assignment',
              WorkRequestStatus.rejected => 'Request rejected',
              _ => throw ArgumentError.value(status),
            },
            actor: 'Admin',
            occurredAt: DateTime.now(),
            reason: reason.trim(),
          ),
        ],
      ),
    );
  }

  void assignTechnician({
    required String requestId,
    required String technicianId,
    required String technicianName,
    String reason = '',
  }) {
    final request = _requests.firstWhere((item) => item.id == requestId);
    if (request.status != WorkRequestStatus.readyToAssign &&
        request.status != WorkRequestStatus.assigned) {
      throw StateError('Request must be approved before assignment.');
    }
    final isReassignment = request.status == WorkRequestStatus.assigned;
    if (isReassignment && reason.trim().isEmpty) {
      throw ArgumentError.value(
        reason,
        'reason',
        'Reassignment needs a reason',
      );
    }
    _updateRequest(
      requestId,
      (current) => current.copyWith(
        status: WorkRequestStatus.assigned,
        assignedTechnicianId: technicianId,
        assignedTechnicianName: technicianName,
        history: [
          ...current.history,
          AdminRequestEvent(
            label: isReassignment
                ? 'Technician reassigned'
                : 'Assigned to technician',
            actor: 'Admin',
            occurredAt: DateTime.now(),
            reason: reason.trim().isEmpty ? null : reason.trim(),
            technicianName: technicianName,
          ),
        ],
      ),
    );
  }

  void _updateRequest(
    String id,
    AdminRequestRecord Function(AdminRequestRecord request) update,
  ) {
    final index = _requests.indexWhere((item) => item.id == id);
    if (index < 0) {
      throw ArgumentError.value(id, 'requestId', 'Unknown request');
    }
    _requests[index] = update(_requests[index]);
    notifyListeners();
  }
}

AdminRequestRecord _seedRequest({
  required String id,
  required String number,
  required String tenant,
  required String apartment,
  required String building,
  required String category,
  required String description,
  required String priority,
  required WorkRequestStatus status,
  required DateTime createdAt,
  String? technicianId,
  String? technicianName,
  List<AdminRequestEvent>? history,
}) => AdminRequestRecord(
  id: id,
  requestNumber: number,
  tenantName: tenant,
  apartment: apartment,
  building: building,
  category: category,
  description: description,
  priority: priority,
  createdAt: createdAt,
  status: status,
  assignedTechnicianId: technicianId,
  assignedTechnicianName: technicianName,
  history:
      history ??
      [
        AdminRequestEvent(
          label: 'Request submitted',
          actor: 'Resident',
          occurredAt: createdAt,
        ),
      ],
);
