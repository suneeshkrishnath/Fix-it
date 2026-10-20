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
          scheduledAt: DateTime.now().add(const Duration(days: 1)),
          appointmentProposal: AppointmentProposal(
            proposedAt: DateTime.now().add(const Duration(days: 2)),
            reason: 'Technician needs a later access window.',
          ),
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

  void proposeAppointmentChange({
    required String requestId,
    required DateTime proposedAt,
    required String reason,
  }) {
    final request = _requests.firstWhere((item) => item.id == requestId);
    if (request.status != WorkRequestStatus.assigned) {
      throw StateError('Only assigned requests can change appointments.');
    }
    if (proposedAt.isBefore(DateTime.now())) {
      throw ArgumentError.value(proposedAt, 'proposedAt', 'Must be in future');
    }
    if (reason.trim().isEmpty) {
      throw ArgumentError.value(reason, 'reason', 'A reason is required');
    }
    if (request.appointmentProposal != null &&
        request.appointmentProposal!.tenantDecision ==
            AppointmentDecision.pending &&
        request.appointmentProposal!.adminDecision ==
            AppointmentDecision.pending) {
      throw StateError('Resolve the current appointment proposal first.');
    }
    _updateRequest(
      requestId,
      (current) => current.copyWith(
        appointmentProposal: AppointmentProposal(
          proposedAt: proposedAt,
          reason: reason.trim(),
        ),
        history: [
          ...current.history,
          AdminRequestEvent(
            label: 'Appointment change proposed',
            actor: current.assignedTechnicianName ?? 'Technician',
            occurredAt: DateTime.now(),
            reason: reason.trim(),
          ),
        ],
      ),
    );
  }

  void recordAppointmentDecision({
    required String requestId,
    required bool byTenant,
    required AppointmentDecision decision,
    String reason = '',
  }) {
    if (decision == AppointmentDecision.pending) {
      throw ArgumentError.value(decision, 'decision', 'Decision must be final');
    }
    if (decision == AppointmentDecision.rejected && reason.trim().isEmpty) {
      throw ArgumentError.value(reason, 'reason', 'Rejection needs a reason');
    }
    final request = _requests.firstWhere((item) => item.id == requestId);
    final proposal = request.appointmentProposal;
    if (proposal == null ||
        proposal.tenantDecision == AppointmentDecision.rejected ||
        proposal.adminDecision == AppointmentDecision.rejected ||
        (byTenant
            ? proposal.tenantDecision != AppointmentDecision.pending
            : proposal.adminDecision != AppointmentDecision.pending)) {
      throw StateError('No decision is pending for this reviewer.');
    }
    final now = DateTime.now();
    final updatedProposal = byTenant
        ? proposal.copyWith(tenantDecision: decision, tenantDecisionAt: now)
        : proposal.copyWith(adminDecision: decision, adminDecisionAt: now);
    final approvedByBoth =
        updatedProposal.tenantDecision == AppointmentDecision.approved &&
        updatedProposal.adminDecision == AppointmentDecision.approved;
    final rejected = decision == AppointmentDecision.rejected;
    _updateRequest(
      requestId,
      (current) => current.copyWith(
        appointmentProposal: updatedProposal,
        scheduledAt: approvedByBoth
            ? updatedProposal.proposedAt
            : current.scheduledAt,
        history: [
          ...current.history,
          AdminRequestEvent(
            label: byTenant
                ? 'Tenant ${decision.name} appointment proposal'
                : 'Admin ${decision.name} appointment proposal',
            actor: byTenant ? 'Tenant (preview)' : 'Admin',
            occurredAt: now,
            reason: reason.trim().isEmpty ? null : reason.trim(),
          ),
          if (approvedByBoth)
            AdminRequestEvent(
              label: 'Appointment change confirmed',
              actor: 'System (local preview)',
              occurredAt: now,
            ),
          if (rejected)
            AdminRequestEvent(
              label: 'Existing appointment retained',
              actor: 'System (local preview)',
              occurredAt: now,
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
  DateTime? scheduledAt,
  AppointmentProposal? appointmentProposal,
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
  scheduledAt: scheduledAt,
  appointmentProposal: appointmentProposal,
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
