import 'service_request.dart';

List<ServiceRequest> filterServiceRequests(
  List<ServiceRequest> requests, {
  String? category,
  ServiceRequestStatus? status,
  DateTime? startDate,
  DateTime? endDate,
}) {
  final start = startDate == null
      ? null
      : DateTime(startDate.year, startDate.month, startDate.day);
  final endExclusive = endDate == null
      ? null
      : DateTime(endDate.year, endDate.month, endDate.day + 1);

  return requests.where((request) {
    if (category != null && request.category != category) return false;
    if (status != null && request.status != status) return false;
    if (start != null && request.createdAt.isBefore(start)) return false;
    if (endExclusive != null && !request.createdAt.isBefore(endExclusive)) {
      return false;
    }
    return true;
  }).toList();
}