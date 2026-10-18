import '../models/closed_case.dart';

abstract interface class ClosedCaseRepository {
  Future<List<ClosedCase>> listClosedCases();

  Technician technicianForRequest(String requestId);
}
