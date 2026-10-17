import 'package:hive/hive.dart';

import '../../domain/models/service_request.dart';
import '../../domain/repositories/service_request_repository.dart';

class HiveServiceRequestRepository implements ServiceRequestRepository {
  HiveServiceRequestRepository(this._box);

  final Box<dynamic> _box;

  @override
  Future<List<ServiceRequest>> listRequests() async => _box.values
      .whereType<Map>()
      .map(ServiceRequest.fromMap)
      .toList()
    ..sort((first, second) => second.createdAt.compareTo(first.createdAt));

  @override
  Future<ServiceRequest> createRequest({
    required String category,
    required String subcategory,
    required String description,
    required ServicePriority priority,
    DateTime? preferredVisitAt,
    List<String> attachmentPaths = const [],
  }) async {
    final createdAt = DateTime.now();
    final id = createdAt.microsecondsSinceEpoch.toString();
    final request = ServiceRequest(
      id: id,
      requestNumber: 'FX-${id.substring(id.length - 6)}',
      category: category,
      subcategory: subcategory,
      description: description,
      priority: priority,
      createdAt: createdAt,
      preferredVisitAt: preferredVisitAt,
      attachmentPaths: attachmentPaths,
    );
    await _box.put(id, request.toMap());
    return request;
  }

  @override
  Future<void> updateRequest(ServiceRequest request) =>
      _box.put(request.id, request.toMap());
}