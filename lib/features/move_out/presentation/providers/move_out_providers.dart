import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../data/repositories/hive_move_out_repository.dart';
import '../../domain/models/move_out_request.dart';
import '../../domain/repositories/move_out_repository.dart';

final moveOutRepositoryProvider = Provider<MoveOutRepository>(
  (ref) => HiveMoveOutRepository(Hive.box<dynamic>('move_out_requests')),
);

final moveOutRequestsProvider =
    AsyncNotifierProvider<MoveOutController, List<MoveOutRequest>>(
  MoveOutController.new,
);

class MoveOutController extends AsyncNotifier<List<MoveOutRequest>> {
  MoveOutRepository get _repository => ref.read(moveOutRepositoryProvider);

  @override
  Future<List<MoveOutRequest>> build() => _repository.listRequests();

  Future<MoveOutRequest> submit({
    required DateTime moveOutDate,
    required String reason,
    required String contactNumber,
    required String forwardingAddress,
    String notes = '',
  }) async {
    final request = await _repository.createRequest(
      moveOutDate: moveOutDate,
      reason: reason,
      contactNumber: contactNumber,
      forwardingAddress: forwardingAddress,
      notes: notes,
    );
    state = AsyncData(await _repository.listRequests());
    return request;
  }
}
