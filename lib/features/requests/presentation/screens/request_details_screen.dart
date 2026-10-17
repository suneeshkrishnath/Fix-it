import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/service_request.dart';
import '../providers/service_request_providers.dart';

class RequestDetailsScreen extends ConsumerWidget {
  const RequestDetailsScreen({required this.requestId, super.key});

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(serviceRequestsProvider).when(
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => Scaffold(
            appBar: AppBar(title: const Text('Request details')),
            body: Center(child: Text('Could not load request: $error')),
          ),
          data: (requests) {
            final matches = requests.where((request) => request.id == requestId);
            if (matches.isEmpty) {
              return Scaffold(
                appBar: AppBar(title: const Text('Request details')),
                body: const Center(child: Text('Request not found.')),
              );
            }
            return _RequestDetails(request: matches.first);
          },
        );
  }
}

class _RequestDetails extends StatelessWidget {
  const _RequestDetails({required this.request});

  final ServiceRequest request;

  @override
  Widget build(BuildContext context) {
    final timeline = _statusTimeline(request.status);
    return Scaffold(
      appBar: AppBar(title: Text(request.requestNumber)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            request.category,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(request.subcategory),
          const SizedBox(height: 16),
          Text(request.description),
          const SizedBox(height: 24),
          Text('Request status', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          for (var index = 0; index < timeline.length; index++)
            _TimelineEntry(
              status: timeline[index],
              isCurrent: index == timeline.length - 1,
              isLast: index == timeline.length - 1,
              submittedAt: index == 0 ? request.createdAt : null,
            ),
          const SizedBox(height: 16),
          Text(
            'Status shown is the latest information saved on this device.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.status,
    required this.isCurrent,
    required this.isLast,
    this.submittedAt,
  });

  final ServiceRequestStatus status;
  final bool isCurrent;
  final bool isLast;
  final DateTime? submittedAt;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final activeColor = isCurrent ? colors.primary : colors.outline;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Icon(
                  isCurrent ? Icons.radio_button_checked : Icons.check_circle,
                  size: 20,
                  color: activeColor,
                ),
                if (!isLast)
                  Expanded(child: Container(width: 2, color: colors.outlineVariant)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_statusLabel(status)),
                  if (submittedAt != null)
                    Text(
                      MaterialLocalizations.of(context)
                          .formatMediumDate(submittedAt!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<ServiceRequestStatus> _statusTimeline(ServiceRequestStatus current) {
  const standard = [
    ServiceRequestStatus.submitted,
    ServiceRequestStatus.accepted,
    ServiceRequestStatus.assigned,
    ServiceRequestStatus.appointmentScheduled,
    ServiceRequestStatus.inProgress,
    ServiceRequestStatus.completed,
  ];
  if (current == ServiceRequestStatus.rejected ||
      current == ServiceRequestStatus.cancelled) {
    return [ServiceRequestStatus.submitted, current];
  }
  return standard.take(standard.indexOf(current) + 1).toList();
}

String _statusLabel(ServiceRequestStatus status) => switch (status) {
      ServiceRequestStatus.submitted => 'Submitted',
      ServiceRequestStatus.accepted => 'Accepted',
      ServiceRequestStatus.assigned => 'Assigned',
      ServiceRequestStatus.appointmentScheduled => 'Appointment scheduled',
      ServiceRequestStatus.inProgress => 'In progress',
      ServiceRequestStatus.completed => 'Completed',
      ServiceRequestStatus.rejected => 'Rejected',
      ServiceRequestStatus.cancelled => 'Cancelled',
    };