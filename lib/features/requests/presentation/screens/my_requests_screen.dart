import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../domain/models/service_request.dart';
import '../providers/service_request_providers.dart';

class MyRequestsScreen extends ConsumerWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(serviceRequestsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My requests')),
      body: requests.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Could not load requests: $error'),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No service requests yet.'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(serviceRequestsProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final request = items[index];
                return ListTile(
                  key: Key('request-${request.id}'),
                  title: Text('${request.requestNumber} · ${request.category}'),
                  subtitle: Text(
                    '${request.subcategory} · ${_statusLabel(request.status)}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      context.push(AppRoutes.requestDetails(request.id)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

String _statusLabel(ServiceRequestStatus status) => switch (status) {
  ServiceRequestStatus.submitted => 'Submitted',
  ServiceRequestStatus.accepted => 'Accepted',
  ServiceRequestStatus.assigned => 'Assigned',
  ServiceRequestStatus.appointmentScheduled => 'Appointment scheduled',
  ServiceRequestStatus.inProgress => 'In progress',
  ServiceRequestStatus.completed => 'Completed',
  ServiceRequestStatus.awaitingTenantConfirmation =>
    'Awaiting tenant confirmation',
  ServiceRequestStatus.closed => 'Closed by tenant',
  ServiceRequestStatus.reopened => 'Reopened',
  ServiceRequestStatus.rejected => 'Rejected',
  ServiceRequestStatus.cancelled => 'Cancelled',
};
