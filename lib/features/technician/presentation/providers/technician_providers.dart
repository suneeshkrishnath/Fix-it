import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../requests/domain/models/service_request.dart';
import '../../../requests/presentation/providers/service_request_providers.dart';
import '../../data/repositories/mock_technician_assignment_repository.dart';
import '../../data/repositories/mock_technician_session_repository.dart';
import '../../domain/repositories/technician_assignment_repository.dart';
import '../../domain/repositories/technician_session_repository.dart';

final technicianSessionRepositoryProvider =
    Provider<TechnicianSessionRepository>((ref) {
      final box = Hive.isBoxOpen('fix_it') ? Hive.box<dynamic>('fix_it') : null;
      return MockTechnicianSessionRepository(box);
    });

final technicianAssignmentRepositoryProvider =
    Provider<TechnicianAssignmentRepository>(
      (ref) => MockTechnicianAssignmentRepository(
        ref.read(serviceRequestRepositoryProvider),
      ),
    );

final technicianSessionProvider =
    NotifierProvider<TechnicianSessionController, String?>(
      TechnicianSessionController.new,
    );

class TechnicianSessionController extends Notifier<String?> {
  TechnicianSessionRepository get _repository =>
      ref.read(technicianSessionRepositoryProvider);

  @override
  String? build() => _repository.readTechnicianId();

  Future<bool> signIn(String technicianId) async {
    final accepted = await _repository.signIn(technicianId);
    state = accepted ? technicianId.trim().toUpperCase() : null;
    return accepted;
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = null;
  }
}

final technicianAssignmentsProvider = FutureProvider<List<ServiceRequest>>((
  ref,
) {
  final technicianId = ref.watch(technicianSessionProvider);
  if (technicianId == null) return Future.value(const []);
  return ref
      .read(technicianAssignmentRepositoryProvider)
      .listAssignments(technicianId);
});
