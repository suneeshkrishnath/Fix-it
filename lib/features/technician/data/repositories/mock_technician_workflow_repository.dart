import '../../domain/models/technician_workflow_sample.dart';

class MockTechnicianWorkflowRepository {
  const MockTechnicianWorkflowRepository();

    List<TechnicianWorkflowSample> listExamples() => [
      TechnicianWorkflowSample(
      requestNumber: 'FX-DEMO-201',
      status: TechnicianWorkflowStatus.workAccepted,
      technicianName: 'Rashid Al Mansoori',
      happenedAt: DateTime(2026, 10, 20, 8, 15),
    ),
    TechnicianWorkflowSample(
      requestNumber: 'FX-DEMO-202',
      status: TechnicianWorkflowStatus.workRejected,
      technicianName: 'Imran Qureshi',
      happenedAt: DateTime(2026, 10, 20, 8, 30),
      reason: 'Required access instructions are missing.',
    ),
    TechnicianWorkflowSample(
      requestNumber: 'FX-DEMO-203',
      status: TechnicianWorkflowStatus.travellingToSite,
      technicianName: 'Rashid Al Mansoori',
      happenedAt: DateTime(2026, 10, 20, 9),
    ),
    TechnicianWorkflowSample(
      requestNumber: 'FX-DEMO-204',
      status: TechnicianWorkflowStatus.workStarted,
      technicianName: 'Imran Qureshi',
      happenedAt: DateTime(2026, 10, 20, 9, 20),
    ),
    TechnicianWorkflowSample(
      requestNumber: 'FX-DEMO-205',
      status: TechnicianWorkflowStatus.workBlocked,
      technicianName: 'Rashid Al Mansoori',
      happenedAt: DateTime(2026, 10, 20, 10),
      reason: 'A replacement part is required before work can continue.',
    ),
    TechnicianWorkflowSample(
      requestNumber: 'FX-DEMO-206',
      status: TechnicianWorkflowStatus.workCompletedAwaitingConfirmation,
      technicianName: 'Imran Qureshi',
      happenedAt: DateTime(2026, 10, 20, 11, 10),
      elapsedMinutes: 42,
    ),
    TechnicianWorkflowSample(
      requestNumber: 'FX-DEMO-207',
      status: TechnicianWorkflowStatus.closed,
      technicianName: 'Rashid Al Mansoori',
      happenedAt: DateTime(2026, 10, 19, 16, 30),
      elapsedMinutes: 55,
    ),
    TechnicianWorkflowSample(
      requestNumber: 'FX-DEMO-208',
      status: TechnicianWorkflowStatus.reopened,
      technicianName: 'Imran Qureshi',
      happenedAt: DateTime(2026, 10, 20, 12),
      reason: 'The repaired switch is still intermittently failing.',
    ),
  ];
}
