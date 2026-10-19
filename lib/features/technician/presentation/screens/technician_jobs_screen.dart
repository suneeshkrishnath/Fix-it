import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations_extension.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/service_localization.dart';
import '../../../requests/domain/models/service_request.dart';
import '../providers/technician_providers.dart';

class TechnicianJobsScreen extends ConsumerWidget {
  const TechnicianJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignments = ref.watch(technicianAssignmentsProvider);
    final l10n = context.l10n;
    return DefaultTabController(
      length: 2,
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
