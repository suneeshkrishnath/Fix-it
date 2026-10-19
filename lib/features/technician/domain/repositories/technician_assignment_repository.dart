import '../../../requests/domain/models/service_request.dart';

enum AppointmentProposalDecision { approve, reject }

abstract interface class TechnicianAssignmentRepository {
  Future<List<ServiceRequest>> listAssignments(String technicianId);

  Future<void> updateStatus(
    String requestId,
    ServiceRequestStatus status, {
    String? completionComments,
  });

  Future<void> proposeAppointmentChange(
    String requestId,
    DateTime proposedAppointmentAt,
  );

  Future<void> recordAppointmentDecision({
    required String requestId,
    required AppointmentProposalDecision decision,
    required bool byAdministrator,
  });
}
