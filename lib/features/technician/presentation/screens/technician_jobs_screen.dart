import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations_extension.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/service_localization.dart';
import '../../data/repositories/mock_technician_workflow_repository.dart';
import '../../domain/models/technician_workflow_sample.dart';
import '../../../requests/domain/models/service_request.dart';
import '../providers/technician_providers.dart';

class TechnicianJobsScreen extends ConsumerWidget {
  const TechnicianJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignments = ref.watch(technicianAssignmentsProvider);
    final l10n = context.l10n;
    final workflowExamples = const MockTechnicianWorkflowRepository()
        .listExamples();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.technicianJobs),
          actions: [
            IconButton(
              tooltip: l10n.signOut,
              onPressed: () async {
                await ref.read(technicianSessionProvider.notifier).signOut();
                if (context.mounted) context.go('/login');
              },
              icon: const Icon(Icons.logout),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.assignedJobs),
              Tab(text: l10n.workHistory),
              Tab(text: l10n.workflowExamples),
            ],
          ),
        ),
        body: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.sampleAssignmentsNotice),
            ),
            Expanded(
              child: assignments.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(l10n.couldNotLoadAssignments(error.toString())),
                  ),
                ),
                data: (items) => TabBarView(
                  children: [
                    _AssignmentList(
                      l10n: l10n,
                      assignments: items
                          .where((item) => !_isHistory(item.status))
                          .toList(),
                    ),
                    _AssignmentList(
                      l10n: l10n,
                      assignments: items
                          .where((item) => _isHistory(item.status))
                          .toList(),
                    ),
                    _WorkflowExamplesList(examples: workflowExamples),
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

class _WorkflowExamplesList extends StatelessWidget {
  const _WorkflowExamplesList({required this.examples});

  final List<TechnicianWorkflowSample> examples;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dateLocalizations = MaterialLocalizations.of(context);
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: examples.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final example = examples[index];
        return Card(
          key: Key('workflow-sample-${example.status.name}'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  example.requestNumber,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(_workflowStatusLabel(l10n, example.status)),
                Text(
                  '${example.technicianName} · ${dateLocalizations.formatMediumDate(example.happenedAt)} ${dateLocalizations.formatTimeOfDay(TimeOfDay.fromDateTime(example.happenedAt))}',
                ),
                if (example.reason != null) ...[
                  const SizedBox(height: 6),
                  Text('${l10n.workflowReason}: ${example.reason}'),
                ],
                if (example.elapsedMinutes != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    l10n.workflowElapsedMinutes(
                      example.elapsedMinutes.toString(),
                    ),
                  ),
                ],
                const Divider(height: 24),
                Text(
                  l10n.tenantNotification,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(_tenantWorkflowNotice(l10n, example)),
                const SizedBox(height: 8),
                Text(
                  l10n.adminNotification,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(_adminWorkflowNotice(l10n, example)),
              ],
            ),
          ),
        );
      },
    );
  }
}

String _workflowStatusLabel(
  AppLocalizations l10n,
  TechnicianWorkflowStatus status,
) => switch (status) {
  TechnicianWorkflowStatus.workAccepted => l10n.workflowStatusWorkAccepted,
  TechnicianWorkflowStatus.workRejected => l10n.workflowStatusWorkRejected,
  TechnicianWorkflowStatus.travellingToSite => l10n.workflowStatusTravelling,
  TechnicianWorkflowStatus.workStarted => l10n.workflowStatusWorkStarted,
  TechnicianWorkflowStatus.workBlocked => l10n.workflowStatusWorkBlocked,
  TechnicianWorkflowStatus.workCompletedAwaitingConfirmation =>
    l10n.workflowStatusWorkCompleted,
  TechnicianWorkflowStatus.closed => l10n.workflowStatusClosed,
  TechnicianWorkflowStatus.reopened => l10n.workflowStatusReopened,
};

String _tenantWorkflowNotice(
  AppLocalizations l10n,
  TechnicianWorkflowSample sample,
) => switch (sample.status) {
  TechnicianWorkflowStatus.workAccepted => l10n.tenantNotifiedWorkAccepted,
  TechnicianWorkflowStatus.workRejected => l10n.tenantNotNotifiedDuringReview,
  TechnicianWorkflowStatus.travellingToSite => l10n.tenantNotifiedTravelling,
  TechnicianWorkflowStatus.workStarted => l10n.tenantNotifiedWorkStarted,
  TechnicianWorkflowStatus.workBlocked => l10n.tenantNotifiedWorkBlocked,
  TechnicianWorkflowStatus.workCompletedAwaitingConfirmation =>
    l10n.tenantNotifiedWorkCompleted,
  TechnicianWorkflowStatus.closed => l10n.tenantNotifiedClosed,
  TechnicianWorkflowStatus.reopened => l10n.tenantNotifiedReopened,
};

String _adminWorkflowNotice(
  AppLocalizations l10n,
  TechnicianWorkflowSample sample,
) => switch (sample.status) {
  TechnicianWorkflowStatus.workAccepted => l10n.adminNotifiedWorkAccepted,
  TechnicianWorkflowStatus.workRejected => l10n.adminNotifiedWorkRejected,
  TechnicianWorkflowStatus.travellingToSite => l10n.adminNotifiedTravelling,
  TechnicianWorkflowStatus.workStarted => l10n.adminNotifiedWorkStarted,
  TechnicianWorkflowStatus.workBlocked => l10n.adminNotifiedWorkBlocked,
  TechnicianWorkflowStatus.workCompletedAwaitingConfirmation =>
    l10n.adminNotifiedWorkCompleted,
  TechnicianWorkflowStatus.closed => l10n.adminNotifiedClosed,
  TechnicianWorkflowStatus.reopened => l10n.adminNotifiedReopened,
};

class _AssignmentList extends StatelessWidget {
  const _AssignmentList({required this.assignments, required this.l10n});

  final List<ServiceRequest> assignments;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    if (assignments.isEmpty) {
      return Center(child: Text(l10n.noAssignments));
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
            title: Text(
              '${assignment.requestNumber} · ${localizedServiceCategory(l10n, assignment.category)}',
            ),
            subtitle: Text(
              '${localizedServiceType(l10n, assignment.subcategory)}\n${assignment.location ?? l10n.locationUnavailable}\n${assignment.awaitingTenantConfirmation ? l10n.workCompletedAwaitingTenant : localizedStatus(l10n, assignment.status.name)}',
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
