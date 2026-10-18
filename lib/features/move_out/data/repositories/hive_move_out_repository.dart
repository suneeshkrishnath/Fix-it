import 'package:hive/hive.dart';

import '../../domain/models/move_out_request.dart';
import '../../domain/repositories/move_out_repository.dart';

class HiveMoveOutRepository implements MoveOutRepository {
  HiveMoveOutRepository(this._box);

  final Box<dynamic> _box;

  @override
  Future<List<MoveOutRequest>> listRequests() async => _box.values
      .whereType<Map>()
      .map(MoveOutRequest.fromMap)
      .toList()
    ..sort((first, second) => second.createdAt.compareTo(first.createdAt));

  @override
  Future<MoveOutRequest> createRequest({
    required DateTime moveOutDate,
    required String reason,
    required String contactNumber,
    required String forwardingAddress,
    String notes = '',
  }) async {
    final createdAt = DateTime.now();
    final request = MoveOutRequest(
      id: createdAt.microsecondsSinceEpoch.toString(),
      moveOutDate: moveOutDate,
      reason: reason,
      contactNumber: contactNumber,
      forwardingAddress: forwardingAddress,
      notes: notes,
      createdAt: createdAt,
    );
    await _box.put(request.id, request.toMap());
    return request;
  }
}
