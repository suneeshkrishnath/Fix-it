import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/mock_closed_case_repository.dart';
import '../../domain/models/closed_case.dart';
import '../../domain/repositories/closed_case_repository.dart';

final closedCaseRepositoryProvider = Provider<ClosedCaseRepository>(
  (ref) => const MockClosedCaseRepository(),
);

final closedCasesProvider = FutureProvider<List<ClosedCase>>(
  (ref) => ref.read(closedCaseRepositoryProvider).listClosedCases(),
);
