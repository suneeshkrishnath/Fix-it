import '../models/move_out_request.dart';

abstract interface class MoveOutRepository {
  Future<List<MoveOutRequest>> listRequests();

  Future<MoveOutRequest> createRequest({
    required DateTime moveOutDate,
    required String reason,
    required String contactNumber,
    required String forwardingAddress,
    String notes,
  });
}
