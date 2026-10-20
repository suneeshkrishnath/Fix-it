import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations_extension.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/models/demo_notification.dart';
import '../providers/notification_providers.dart';

class NotificationCenterScreen extends ConsumerStatefulWidget {
  const NotificationCenterScreen({required this.initialAudience, super.key});

  final NotificationAudience initialAudience;

  @override
  ConsumerState<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState
    extends ConsumerState<NotificationCenterScreen> {
  late var _audience = widget.initialAudience;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final notifications =
        ref
            .watch(demoNotificationsProvider)
            .where((item) => item.audience == _audience)
            .toList()
          ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationCenter)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SegmentedButton<NotificationAudience>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: NotificationAudience.tenant,
                  label: Text(l10n.notificationAudienceTenant),
                ),
                ButtonSegment(
                  value: NotificationAudience.technician,
                  label: Text(l10n.notificationAudienceTechnician),
                ),
                ButtonSegment(
                  value: NotificationAudience.administrator,
                  label: Text(l10n.notificationAudienceAdminPreview),
                ),
              ],
              selected: {_audience},
              onSelectionChanged: (selection) =>
                  setState(() => _audience = selection.first),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.notificationExamplesNotice),
          ),
          Expanded(
            child: notifications.isEmpty
                ? Center(child: Text(l10n.notificationInboxEmpty))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) =>
                        _NotificationCard(notification: notifications[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification});

  final DemoNotification notification;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dateLocalizations = MaterialLocalizations.of(context);
    return Card(
      key: Key('notification-${notification.id}'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _eventTitle(l10n, notification.event),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              '${l10n.notificationRequestLabel}: ${notification.requestNumber}',
            ),
            if (notification.technicianName != null)
              Text('${l10n.technicianName}: ${notification.technicianName}'),
            Text(_eventBody(l10n, notification)),
            if (notification.reason != null)
              Text('${l10n.workflowReason}: ${notification.reason}'),
            if (notification.elapsedMinutes != null)
              Text(
                l10n.workflowElapsedMinutes(
                  notification.elapsedMinutes.toString(),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              '${l10n.workflowEventTime}: ${dateLocalizations.formatMediumDate(notification.occurredAt)} ${dateLocalizations.formatTimeOfDay(TimeOfDay.fromDateTime(notification.occurredAt))}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

String _eventTitle(AppLocalizations l10n, NotificationEvent event) =>
    switch (event) {
      NotificationEvent.workAccepted => l10n.workflowStatusWorkAccepted,
      NotificationEvent.workRejected => l10n.workflowStatusWorkRejected,
      NotificationEvent.travellingToSite => l10n.workflowStatusTravelling,
      NotificationEvent.workStarted => l10n.workflowStatusWorkStarted,
      NotificationEvent.workBlocked => l10n.workflowStatusWorkBlocked,
      NotificationEvent.workCompleted => l10n.workflowStatusWorkCompleted,
      NotificationEvent.tenantAccepted => l10n.notificationTenantAcceptedTitle,
      NotificationEvent.tenantRejected => l10n.notificationTenantRejectedTitle,
      NotificationEvent.administratorApproved =>
        l10n.notificationAdminApprovedTitle,
      NotificationEvent.workOrderClosed => l10n.workflowStatusClosed,
      NotificationEvent.reopened => l10n.workflowStatusReopened,
      NotificationEvent.technicianAssigned => l10n.assignedTechnician,
      NotificationEvent.appointmentProposalApproved =>
        l10n.notificationProposalDecisionTitle,
    };

String _eventBody(AppLocalizations l10n, DemoNotification notification) {
  final requestNumber = notification.requestNumber;
  final technicianName = notification.technicianName ?? '';
  return switch ((notification.event, notification.audience)) {
    (NotificationEvent.workAccepted, NotificationAudience.tenant) =>
      l10n.notificationAcceptedTenant(requestNumber, technicianName),
    (NotificationEvent.workAccepted, _) => l10n.notificationAcceptedAdmin(
      requestNumber,
      technicianName,
    ),
    (NotificationEvent.workRejected, NotificationAudience.administrator) =>
      l10n.notificationRejectedAdmin(requestNumber),
    (NotificationEvent.workRejected, NotificationAudience.tenant) =>
      l10n.tenantNotNotifiedDuringReview,
    (NotificationEvent.workRejected, NotificationAudience.technician) =>
      l10n.notificationWorkRejectedTechnician(requestNumber),
    (NotificationEvent.travellingToSite, NotificationAudience.tenant) =>
      l10n.notificationTravellingTenant(technicianName),
    (NotificationEvent.travellingToSite, _) => l10n.notificationTravellingAdmin(
      requestNumber,
    ),
    (NotificationEvent.workStarted, NotificationAudience.tenant) =>
      l10n.notificationStartedTenant(requestNumber),
    (NotificationEvent.workStarted, _) => l10n.notificationStartedAdmin(
      requestNumber,
    ),
    (NotificationEvent.workBlocked, NotificationAudience.tenant) =>
      l10n.notificationBlockedTenant(notification.reason ?? ''),
    (NotificationEvent.workBlocked, _) => l10n.notificationBlockedAdmin(
      requestNumber,
    ),
    (NotificationEvent.workCompleted, NotificationAudience.tenant) =>
      l10n.notificationCompletedTenant(requestNumber),
    (NotificationEvent.workCompleted, _) => l10n.notificationCompletedAdmin(
      requestNumber,
      notification.elapsedMinutes?.toString() ?? '0',
    ),
    (NotificationEvent.tenantAccepted, _) =>
      l10n.notificationTenantAcceptedAdmin(requestNumber),
    (NotificationEvent.tenantRejected, _) =>
      l10n.notificationTenantRejectedAdmin(requestNumber),
    (NotificationEvent.administratorApproved, _) =>
      l10n.notificationAdminApproved(requestNumber),
    (NotificationEvent.workOrderClosed, NotificationAudience.tenant) =>
      l10n.notificationClosedTenant(requestNumber),
    (NotificationEvent.workOrderClosed, _) => l10n.notificationClosedAdmin(
      requestNumber,
    ),
    (NotificationEvent.reopened, NotificationAudience.tenant) =>
      l10n.notificationReopenedTenant(requestNumber),
    (NotificationEvent.reopened, _) => l10n.notificationReopenedAdmin(
      requestNumber,
    ),
    (NotificationEvent.technicianAssigned, _) =>
      l10n.notificationTechnicianAssigned(requestNumber),
    (NotificationEvent.appointmentProposalApproved, _) =>
      l10n.notificationProposalApprovedTechnician(requestNumber),
  };
}
