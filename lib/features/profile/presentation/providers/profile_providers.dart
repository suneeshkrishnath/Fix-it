import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/mock_resident_profile_repository.dart';
import '../../domain/models/resident_profile.dart';
import '../../domain/repositories/resident_profile_repository.dart';

final residentProfileRepositoryProvider = Provider<ResidentProfileRepository>(
  (ref) => const MockResidentProfileRepository(),
);

final residentProfileProvider = FutureProvider<ResidentProfile?>((ref) {
  final resident = ref.watch(authControllerProvider).resident;
  if (resident == null) return null;
  return ref.read(residentProfileRepositoryProvider).loadProfile(resident);
});
