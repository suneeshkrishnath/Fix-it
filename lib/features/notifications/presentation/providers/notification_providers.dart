import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/mock_notification_repository.dart';
import '../../domain/models/demo_notification.dart';

final mockNotificationRepositoryProvider = Provider<MockNotificationRepository>(
  (ref) => const MockNotificationRepository(),
);

final demoNotificationsProvider = Provider<List<DemoNotification>>(
  (ref) => ref.read(mockNotificationRepositoryProvider).listExamples(),
);
