import '../../../requests/domain/models/service_request.dart';
import '../../../requests/domain/repositories/service_request_repository.dart';
import '../../domain/repositories/technician_assignment_repository.dart';

class MockTechnicianAssignmentRepository
    implements TechnicianAssignmentRepository {
  MockTechnicianAssignmentRepository(this._requests);

  static const demoTechnicianId = 'TECH-001';

  final ServiceRequestRepository _requests;

  @override
  Future<List<ServiceRequest>> listAssignments(String technicianId) async {
    await _ensureSampleAssignments(technicianId);
    final assignments =
        (await _requests.listRequests())
            .where((request) => request.assignedTechnicianId == technicianId)
            .toList()
          ..sort(
            (first, second) => second.createdAt.compareTo(first.createdAt),
          );
    return assignments;
  }

  Future<void> _ensureSampleAssignments(String technicianId) async {
    if (technicianId != demoTechnicianId) return;
    final existing = await _requests.listRequests();
    if (!existing.any(
      (request) => request.isSample && request.subcategory == 'Water leakage',
    )) {
      final appointmentAt = DateTime.now().add(const Duration(days: 1));
      final active = await _requests.createRequest(
        category: 'Plumbing',
        subcategory: 'Water leakage',
        description:
            'Sample assignment: inspect a leak under the kitchen sink.',
        priority: ServicePriority.high,
        preferredVisitAt: appointmentAt,
      );
      await _requests.updateRequest(
        active.copyWith(
          assignedTechnicianId: demoTechnicianId,
          technicianName: 'Rashid Al Mansoori',
          location: 'Apartment A-302, Tower 3, Dubai Marina',
          appointmentAt: appointmentAt,
          isSample: true,
          status: ServiceRequestStatus.assigned,
        ),
      );
    }

    if (!existing.any(
      (request) =>
          request.isSample && request.subcategory == 'Switch maintenance',
    )) {
      final history = await _requests.createRequest(
        category: 'Electrical',
        subcategory: 'Switch maintenance',
        description: 'Sample assignment: replace a faulty bedroom switch.',
        priority: ServicePriority.normal,
      );
      await _requests.updateRequest(
        history.copyWith(
          assignedTechnicianId: demoTechnicianId,
          technicianName: 'Rashid Al Mansoori',
          location: 'Apartment A-302, Tower 3, Dubai Marina',
          appointmentAt: DateTime.now().subtract(const Duration(days: 3)),
          completionComments: 'Replaced the switch and tested the circuit.',
          closedAt: DateTime.now().subtract(const Duration(days: 2)),
          isSample: true,
          status: ServiceRequestStatus.closed,
        ),
      );
    }
  }

  @override
  Future<void> updateStatus(
    String requestId,
    ServiceRequestStatus status, {
    String? completionComments,
  }) async {
    final request = await _findRequest(requestId);
    await _requests.updateRequest(
      request.copyWith(
        status: status,
        completionComments: completionComments,
        awaitingTenantConfirmation:
            status == ServiceRequestStatus.awaitingTenantConfirmation,
        clearClosedAt: status == ServiceRequestStatus.inProgress,
      ),
    );
  }

  @override
  Future<void> proposeAppointmentChange(
    String requestId,
    DateTime proposedAppointmentAt,
  ) async {
    final request = await _findRequest(requestId);
    await _requests.updateRequest(
      request.copyWith(
        proposedAppointmentAt: proposedAppointmentAt,
        tenantApprovedAppointmentChange: false,
        adminApprovedAppointmentChange: false,
      ),
    );
  }

  @override
  Future<void> recordAppointmentDecision({
    required String requestId,
    required AppointmentProposalDecision decision,
    required bool byAdministrator,
  }) async {
    final request = await _findRequest(requestId);
    final proposedAt = request.proposedAppointmentAt;
    if (proposedAt == null) return;
    if (decision == AppointmentProposalDecision.reject) {
      await _requests.updateRequest(
        request.copyWith(clearProposedAppointment: true),
      );
      return;
    }

    final updated = request.copyWith(
      tenantApprovedAppointmentChange: byAdministrator ? null : true,
      adminApprovedAppointmentChange: byAdministrator ? true : null,
    );
    if (updated.tenantApprovedAppointmentChange &&
        updated.adminApprovedAppointmentChange) {
      await _requests.updateRequest(
        updated.copyWith(
          appointmentAt: proposedAt,
          clearProposedAppointment: true,
        ),
      );
    } else {
      await _requests.updateRequest(updated);
    }
  }

  Future<ServiceRequest> _findRequest(String requestId) async {
    for (final request in await _requests.listRequests()) {
      if (request.id == requestId) return request;
    }
    throw StateError('Assignment not found.');
  }
}
