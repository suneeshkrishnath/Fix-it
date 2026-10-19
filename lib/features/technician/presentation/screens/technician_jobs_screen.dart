import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../requests/domain/models/service_request.dart';
import '../providers/technician_providers.dart';

class TechnicianJobsScreen extends ConsumerWidget {
  const TechnicianJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignments = ref.watch(technicianAssignmentsProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Technician jobs'),
          actions: [
            IconButton(
              tooltip: 'Sign out',
              onPressed: () async {
                await ref.read(technicianSessionProvider.notifier).signOut();
                if (context.mounted) context.go('/login');
              },
              icon: const Icon(Icons.logout),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Assigned'),
              Tab(text: 'Work history'),
            ],
          ),
        ),
        body: Column(
          children: [
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text(
                'Sample assignments; changes are saved on this device only.',
              ),
            ),
            Expanded(
              child: assignments.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('Could not load assignments: $error'),
                  ),
                ),
                data: (items) => TabBarView(
                  children: [
                    _AssignmentList(
                      assignments: items
                          .where((item) => !_isHistory(item.status))
                          .toList(),
                    ),
                    _AssignmentList(
                      assignments: items
                          .where((item) => _isHistory(item.status))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssignmentList extends StatelessWidget {
  const _AssignmentList({required this.assignments});

  final List<ServiceRequest> assignments;

  @override
  Widget build(BuildContext context) {
    if (assignments.isEmpty) {
      return const Center(child: Text('No assignments in this list.'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: assignments.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final assignment = assignments[index];
        return Card(
          child: ListTile(
            key: Key('technician-job-${assignment.id}'),
            title: Text('${assignment.requestNumber} · ${assignment.category}'),
            subtitle: Text(
              '${assignment.subcategory}\n${assignment.location ?? 'Location unavailable'}\n${_statusLabel(assignment.status, assignment.awaitingTenantConfirmation)}',
            ),
            isThreeLine: true,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/technician/jobs/${assignment.id}'),
          ),
        );
      },
    );
  }
}

bool _isHistory(ServiceRequestStatus status) =>
    status == ServiceRequestStatus.awaitingTenantConfirmation ||
    status == ServiceRequestStatus.closed ||
    status == ServiceRequestStatus.completed;

String _statusLabel(ServiceRequestStatus status, bool awaitingConfirmation) =>
    awaitingConfirmation
    ? 'Work completed · awaiting tenant confirmation'
    : switch (status) {
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
