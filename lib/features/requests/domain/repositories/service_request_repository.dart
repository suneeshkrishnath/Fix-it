import '../models/service_request.dart';

abstract interface class ServiceRequestRepository {
  Future<List<ServiceRequest>> listRequests();

  Future<ServiceRequest> createRequest({
    required String category,
    required String subcategory,
    required String description,
    required ServicePriority priority,
    DateTime? preferredVisitAt,
    List<String> attachmentPaths,
  });

  Future<void> updateRequest(ServiceRequest request);
}