import 'package:flutter/material.dart';

import '../../../admin_theme.dart';
import '../../requests/data/repositories/mock_admin_request_repository.dart';
import '../../requests/domain/models/admin_request_records.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({required this.requests, super.key});

  final MockAdminRequestRepository requests;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: requests,
    builder: (context, _) {
      final records = requests.requests;
      final closed = records
          .where((request) => request.status == WorkRequestStatus.closed)
          .length;
      final active = records
          .where(
            (request) =>
                request.status == WorkRequestStatus.assigned ||
                request.status == WorkRequestStatus.travelling ||
                request.status == WorkRequestStatus.workStarted ||
                request.status == WorkRequestStatus.workBlocked ||
                request.status == WorkRequestStatus.reopened,
          )
          .length;
      final pendingReview = records
          .where(
            (request) =>
                request.status == WorkRequestStatus.submitted ||
                request.status == WorkRequestStatus.readyToAssign ||
                request.status == WorkRequestStatus.informationRequested ||
                request.status ==
                    WorkRequestStatus.awaitingTenantConfirmation ||
                request.status ==
                    WorkRequestStatus.awaitingAdminClosureApproval ||
                request.status == WorkRequestStatus.reopenPendingReview,
          )
          .length;
      final completions = [
        for (final request in records) ...request.completions,
      ];
      final averageMinutes = completions.isEmpty
          ? 0
          : (completions.fold<int>(
                      0,
                      (total, completion) =>
                          total + completion.elapsedWorkMinutes,
                    ) /
                    completions.length)
                .round();
      final assignmentEvents = records
          .expand((request) => request.history)
          .where(
            (event) =>
                event.label == 'Assigned to technician' ||
                event.label == 'Technician reassigned',
          )
          .length;
      final proposals = records
          .where((request) => request.appointmentProposal != null)
          .map((request) => request.appointmentProposal!)
          .toList();
      final dualApproved = proposals
          .where(
            (proposal) =>
                proposal.tenantDecision == AppointmentDecision.approved &&
                proposal.adminDecision == AppointmentDecision.approved,
          )
          .length;
      final declined = proposals
          .where(
            (proposal) =>
                proposal.tenantDecision == AppointmentDecision.rejected ||
                proposal.adminDecision == AppointmentDecision.rejected,
          )
          .length;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Operational reports'),
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: _ReportBadge(),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            const Text('LOCAL SAMPLE DATA · Current in-memory snapshot'),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 900 ? 4 : 2;
                return GridView.count(
                  crossAxisCount: columns,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 108,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _ReportMetric(
                      label: 'Requests',
                      value: '${records.length}',
                    ),
                    _ReportMetric(label: 'Active work', value: '$active'),
                    _ReportMetric(
                      label: 'Awaiting review',
                      value: '$pendingReview',
                    ),
                    _ReportMetric(label: 'Closed', value: '$closed'),
                    _ReportMetric(
                      label: 'Assignment events',
                      value: '$assignmentEvents',
                    ),
                    _ReportMetric(
                      label: 'Avg. work time',
                      value: '$averageMinutes min',
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Appointment outcomes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  _ReportRow(label: 'Proposals', value: '${proposals.length}'),
                  const Divider(height: 1),
                  _ReportRow(label: 'Approved by both', value: '$dualApproved'),
                  const Divider(height: 1),
                  _ReportRow(label: 'Declined', value: '$declined'),
                  const Divider(height: 1),
                  _ReportRow(
                    label: 'Awaiting one or both decisions',
                    value: '${proposals.length - dualApproved - declined}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Work time and completion history',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (completions.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    'No completed work in the current sample snapshot.',
                  ),
                ),
              )
            else
              Card(
                child: Column(
                  children: [
                    for (final request in records)
                      for (
                        var index = 0;
                        index < request.completions.length;
                        index++
                      ) ...[
                        if (request.completions.take(index).isNotEmpty)
                          const Divider(height: 1),
                        _ReportRow(
                          label:
                              '${request.requestNumber} · attempt ${index + 1}\n${request.assignedTechnicianName ?? 'Unassigned'} · ${request.completions[index].comments}',
                          value:
                              '${request.completions[index].elapsedWorkMinutes} min',
                        ),
                      ],
                  ],
                ),
              ),
            const SizedBox(height: 24),
            Text(
              'Request status breakdown',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  for (
                    var index = 0;
                    index < WorkRequestStatus.values.length;
                    index++
                  ) ...[
                    if (index > 0) const Divider(height: 1),
                    _ReportRow(
                      label: WorkRequestStatus.values[index].label,
                      value:
                          '${records.where((request) => request.status == WorkRequestStatus.values[index]).length}',
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _ReportMetric extends StatelessWidget {
  const _ReportMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(color: AdminTheme.ink, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    ),
  );
}

class _ReportRow extends StatelessWidget {
  const _ReportRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        const SizedBox(width: 12),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
  );
}

class _ReportBadge extends StatelessWidget {
  const _ReportBadge();

  @override
  Widget build(BuildContext context) => const Chip(
    avatar: Icon(Icons.analytics_outlined, size: 16),
    label: Text('SAMPLE REPORT'),
    visualDensity: VisualDensity.compact,
  );
}
