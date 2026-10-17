import 'package:flutter_test/flutter_test.dart';

import 'package:fix_it/features/requests/domain/models/service_request.dart';
import 'package:fix_it/features/requests/domain/models/service_request_filters.dart';

void main() {
  test('date range includes both boundary days', () {
    final requests = [
      _request('before', DateTime(2026, 10, 9)),
      _request('start', DateTime(2026, 10, 10, 23, 59)),
      _request('end', DateTime(2026, 10, 12, 23, 59)),
      _request('after', DateTime(2026, 10, 13)),
    ];

    final filtered = filterServiceRequests(
      requests,
      startDate: DateTime(2026, 10, 10),
      endDate: DateTime(2026, 10, 12),
    );

    expect(filtered.map((request) => request.id), ['start', 'end']);
  });

  test('category and status filters combine', () {
    final requests = [
      _request(
        'match',
        DateTime(2026, 10, 10),
        category: 'Electrical',
        status: ServiceRequestStatus.completed,
      ),
      _request(
        'wrong-status',
        DateTime(2026, 10, 10),
        category: 'Electrical',
        status: ServiceRequestStatus.submitted,
      ),
      _request(
        'wrong-category',
        DateTime(2026, 10, 10),
        category: 'Plumbing',
        status: ServiceRequestStatus.completed,
      ),
    ];

    final filtered = filterServiceRequests(
      requests,
      category: 'Electrical',
      status: ServiceRequestStatus.completed,
    );

    expect(filtered.map((request) => request.id), ['match']);
  });
}

ServiceRequest _request(
  String id,
  DateTime createdAt, {
  String category = 'Plumbing',
  ServiceRequestStatus status = ServiceRequestStatus.submitted,
}) =>
    ServiceRequest(
      id: id,
      requestNumber: id,
      category: category,
      subcategory: 'Water leakage',
      description: 'Test request',
      priority: ServicePriority.normal,
      createdAt: createdAt,
      status: status,
    );