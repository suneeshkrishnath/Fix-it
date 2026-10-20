import 'package:flutter/foundation.dart';

enum AdminNotificationRole { tenant, technician, admin }

enum NotificationPreviewState { sample, retryPreviewQueued }

class NotificationRecipient {
  const NotificationRecipient({required this.name, required this.role});

  final String name;
  final AdminNotificationRole role;

  String get roleLabel => switch (role) {
    AdminNotificationRole.tenant => 'Tenant',
    AdminNotificationRole.technician => 'Technician',
    AdminNotificationRole.admin => 'Admin',
  };
}

class NotificationRetryPreview {
  const NotificationRetryPreview({required this.at, required this.attempt});

  final DateTime at;
  final int attempt;
}

class AdminNotificationPreview {
  const AdminNotificationPreview({
    required this.id,
    required this.requestNumber,
    required this.title,
    required this.eventType,
    required this.payload,
    required this.createdAt,
    required this.recipients,
    this.state = NotificationPreviewState.sample,
    this.retryPreviews = const [],
  });

  final String id;
  final String requestNumber;
  final String title;
  final String eventType;
  final String payload;
  final DateTime createdAt;
  final List<NotificationRecipient> recipients;
  final NotificationPreviewState state;
  final List<NotificationRetryPreview> retryPreviews;

  AdminNotificationPreview copyWith({
    NotificationPreviewState? state,
    List<NotificationRetryPreview>? retryPreviews,
  }) => AdminNotificationPreview(
    id: id,
    requestNumber: requestNumber,
    title: title,
    eventType: eventType,
    payload: payload,
    createdAt: createdAt,
    recipients: recipients,
    state: state ?? this.state,
    retryPreviews: retryPreviews ?? this.retryPreviews,
  );
}

class MockNotificationRepository extends ChangeNotifier {
  final List<AdminNotificationPreview> _events = [
    AdminNotificationPreview(
      id: 'notice-assigned',
      requestNumber: 'REQ-1038',
      title: 'Technician assigned',
      eventType: 'assignment.created',
      payload: 'Imran Qureshi is assigned to the air-conditioning request.',
      createdAt: DateTime(2026, 10, 19, 17),
      recipients: const [
        NotificationRecipient(
          name: 'Noor Ahmed',
          role: AdminNotificationRole.tenant,
        ),
        NotificationRecipient(
          name: 'Imran Qureshi',
          role: AdminNotificationRole.technician,
        ),
        NotificationRecipient(
          name: 'Operations team',
          role: AdminNotificationRole.admin,
        ),
      ],
    ),
    AdminNotificationPreview(
      id: 'notice-travelling',
      requestNumber: 'REQ-1038',
      title: 'Technician travelling to site',
      eventType: 'work.travelling',
      payload: 'Imran Qureshi is on the way to Marina Tower 2, A-114.',
      createdAt: DateTime(2026, 10, 20, 9, 10),
      recipients: const [
        NotificationRecipient(
          name: 'Noor Ahmed',
          role: AdminNotificationRole.tenant,
        ),
        NotificationRecipient(
          name: 'Operations team',
          role: AdminNotificationRole.admin,
        ),
      ],
    ),
    AdminNotificationPreview(
      id: 'notice-completion',
      requestNumber: 'REQ-1038',
      title: 'Completion awaits tenant review',
      eventType: 'work.completion_submitted',
      payload: 'The tenant can accept or reject the recorded work completion.',
      createdAt: DateTime(2026, 10, 20, 10, 5),
      recipients: const [
        NotificationRecipient(
          name: 'Noor Ahmed',
          role: AdminNotificationRole.tenant,
        ),
        NotificationRecipient(
          name: 'Operations team',
          role: AdminNotificationRole.admin,
        ),
      ],
    ),
    AdminNotificationPreview(
      id: 'notice-rejection',
      requestNumber: 'REQ-1041',
      title: 'Technician rejection requires review',
      eventType: 'assignment.rejected',
      payload:
          'Admin preview only: a technician rejection reason is under review.',
      createdAt: DateTime(2026, 10, 20, 8, 30),
      recipients: const [
        NotificationRecipient(
          name: 'Operations team',
          role: AdminNotificationRole.admin,
        ),
      ],
    ),
  ];

  List<AdminNotificationPreview> get events => List.unmodifiable(_events);

  void recordRetryPreview(String id, {DateTime? now}) {
    final index = _events.indexWhere((event) => event.id == id);
    if (index < 0) throw ArgumentError.value(id, 'id', 'Unknown event');
    final event = _events[index];
    final retry = NotificationRetryPreview(
      at: now ?? DateTime.now(),
      attempt: event.retryPreviews.length + 1,
    );
    _events[index] = event.copyWith(
      state: NotificationPreviewState.retryPreviewQueued,
      retryPreviews: [...event.retryPreviews, retry],
    );
    notifyListeners();
  }
}
