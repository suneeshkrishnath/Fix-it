import 'package:flutter/material.dart';

import '../../../admin_theme.dart';
import '../data/repositories/mock_notification_repository.dart';

class AdminNotificationsScreen extends StatefulWidget {
  const AdminNotificationsScreen({required this.repository, super.key});

  final MockNotificationRepository repository;

  @override
  State<AdminNotificationsScreen> createState() =>
      _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  String? _selectedId;
  AdminNotificationRole? _roleFilter;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.repository,
    builder: (context, _) => Scaffold(
      appBar: AppBar(
        title: const Text('Notification previews'),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: _PreviewBadge(),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final events = widget.repository.events
              .where(
                (event) =>
                    _roleFilter == null ||
                    event.recipients.any(
                      (recipient) => recipient.role == _roleFilter,
                    ),
              )
              .toList();
          final selected =
              events.where((event) => event.id == _selectedId).firstOrNull ??
              (events.isEmpty ? null : events.first);
          if (_selectedId == null && selected != null) {
            _selectedId = selected.id;
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'No messages are sent. Provider selection and push delivery remain on hold.',
                  key: Key('notification-preview-notice'),
                  style: TextStyle(color: AdminTheme.ink),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: constraints.maxWidth < 500 ? 190 : 230,
                    child: DropdownButtonFormField<AdminNotificationRole?>(
                      key: const Key('notification-recipient-filter'),
                      initialValue: _roleFilter,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Recipient role',
                        isDense: true,
                      ),
                      items: [
                        const DropdownMenuItem<AdminNotificationRole?>(
                          value: null,
                          child: Text('All recipients'),
                        ),
                        for (final role in AdminNotificationRole.values)
                          DropdownMenuItem<AdminNotificationRole?>(
                            value: role,
                            child: Text(_roleName(role)),
                          ),
                      ],
                      onChanged: (value) => setState(() => _roleFilter = value),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth < 760 ? 255 : 320,
                        child: _eventList(events, selected),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _eventDetails(selected)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );

  Widget _eventList(
    List<AdminNotificationPreview> events,
    AdminNotificationPreview? selected,
  ) => Card(
    clipBehavior: Clip.antiAlias,
    child: events.isEmpty
        ? const Center(child: Text('No preview events for this role.'))
        : ListView.separated(
            itemCount: events.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                key: Key('notification-row-${event.id}'),
                selected: selected?.id == event.id,
                selectedTileColor: AdminTheme.tealLight,
                onTap: () => setState(() => _selectedId = event.id),
                title: Text(event.title),
                subtitle: Text(
                  '${event.requestNumber} · ${event.recipients.length} recipient(s)',
                ),
                trailing: event.retryPreviews.isEmpty
                    ? const Icon(Icons.visibility_outlined)
                    : const Icon(Icons.history),
              );
            },
          ),
  );

  Widget _eventDetails(AdminNotificationPreview? event) => Card(
    child: event == null
        ? const Center(child: Text('Select an event to inspect its preview.'))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text('${event.eventType} · ${event.requestNumber}'),
                const SizedBox(height: 12),
                Text('Payload', style: Theme.of(context).textTheme.titleSmall),
                Text(event.payload),
                const SizedBox(height: 12),
                Text(
                  'Recipients',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                for (final recipient in event.recipients)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(_roleIcon(recipient.role)),
                    title: Text(recipient.name),
                    subtitle: Text(recipient.roleLabel),
                  ),
                const Divider(),
                Text('Created: ${_formatTimestamp(event.createdAt)}'),
                Text(
                  'State: ${event.state == NotificationPreviewState.sample ? 'Sample preview' : 'Retry preview queued'}',
                  key: const Key('notification-preview-state'),
                ),
                Text('Retry previews: ${event.retryPreviews.length}'),
                for (final retry in event.retryPreviews)
                  Text(
                    'Preview retry ${retry.attempt}: ${_formatTimestamp(retry.at)}',
                  ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  key: const Key('record-notification-retry'),
                  onPressed: () =>
                      widget.repository.recordRetryPreview(event.id),
                  icon: const Icon(Icons.replay),
                  label: const Text('Record retry preview'),
                ),
                const Text(
                  'This records a local preview only; no delivery is attempted.',
                ),
              ],
            ),
          ),
  );
}

class _PreviewBadge extends StatelessWidget {
  const _PreviewBadge();

  @override
  Widget build(BuildContext context) => const Chip(
    avatar: Icon(Icons.visibility_outlined, size: 16),
    label: Text('PREVIEW ONLY'),
    visualDensity: VisualDensity.compact,
  );
}

String _roleName(AdminNotificationRole role) => switch (role) {
  AdminNotificationRole.tenant => 'Tenant',
  AdminNotificationRole.technician => 'Technician',
  AdminNotificationRole.admin => 'Admin',
};

IconData _roleIcon(AdminNotificationRole role) => switch (role) {
  AdminNotificationRole.tenant => Icons.person_outline,
  AdminNotificationRole.technician => Icons.engineering_outlined,
  AdminNotificationRole.admin => Icons.admin_panel_settings_outlined,
};

String _formatTimestamp(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$day/$month/${value.year} $hour:$minute';
}
