import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../data/repositories/hive_service_request_repository.dart';
import '../../domain/models/service_request.dart';
import '../../domain/repositories/service_request_repository.dart';

final serviceRequestRepositoryProvider = Provider<ServiceRequestRepository>(
  (ref) => HiveServiceRequestRepository(Hive.box<dynamic>('service_requests')),
);

final serviceRequestsProvider =
    AsyncNotifierProvider<ServiceRequestsController, List<ServiceRequest>>(
      ServiceRequestsController.new,
    );

class ServiceRequestsController extends AsyncNotifier<List<ServiceRequest>> {
  ServiceRequestRepository get _repository =>
      ref.read(serviceRequestRepositoryProvider);

  @override
  Future<List<ServiceRequest>> build() => _repository.listRequests();

  Future<ServiceRequest> createRequest({
    required String category,
    required String subcategory,
    required String description,
    required ServicePriority priority,
    DateTime? preferredVisitAt,
    List<String> attachmentPaths = const [],
  }) async {
    final request = await _repository.createRequest(
      category: category,
      subcategory: subcategory,
      description: description,
      priority: priority,
      preferredVisitAt: preferredVisitAt,
      attachmentPaths: attachmentPaths,
    );
    state = AsyncData(await _repository.listRequests());
    return request;
  }

  Future<void> updateRequest(ServiceRequest request) async {
    await _repository.updateRequest(request);
    state = AsyncData(await _repository.listRequests());
  }
}
