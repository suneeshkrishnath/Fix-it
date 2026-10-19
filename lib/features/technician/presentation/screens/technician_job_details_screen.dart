import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations_extension.dart';
import '../../../../l10n/service_localization.dart';
import '../../../requests/domain/models/service_request.dart';
import '../providers/technician_providers.dart';

class TechnicianJobDetailsScreen extends ConsumerWidget {
  const TechnicianJobDetailsScreen({required this.requestId, super.key});

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final assignments = ref.watch(technicianAssignmentsProvider);
    return assignments.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(title: Text(l10n.jobDetails)),
        body: Center(child: Text(l10n.couldNotLoadJob(error.toString()))),
      ),
      data: (items) {
        final matches = items.where((item) => item.id == requestId);
        if (matches.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.jobDetails)),
            body: Center(child: Text(l10n.assignmentNotFound)),
          );
        }
        return _JobDetails(assignment: matches.first);
      },
    );
  }
}

class _JobDetails extends ConsumerWidget {
  const _JobDetails({required this.assignment});

  final ServiceRequest assignment;

  Future<void> _setStatus(
    BuildContext context,
    WidgetRef ref,
    ServiceRequestStatus status, {
    String? completionComments,
  }) async {
    await ref
        .read(technicianAssignmentRepositoryProvider)
        .updateStatus(
          assignment.id,
          status,
          completionComments: completionComments,
        );
    ref.invalidate(technicianAssignmentsProvider);
  }

  Future<void> _completeWork(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    var completionComments = '';
    final comments = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.completeWork),
        content: TextField(
          key: const Key('completion-comments-field'),
          minLines: 2,
          maxLines: 5,
          onChanged: (value) => completionComments = value,
          decoration: InputDecoration(
            labelText: l10n.closingComments,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            key: const Key('confirm-completion'),
            onPressed: () =>
                Navigator.pop(dialogContext, completionComments.trim()),
            child: Text(l10n.submitCompletion),
          ),
        ],
      ),
    );
    if (comments == null || comments.isEmpty || !context.mounted) return;
    await _setStatus(
      context,
      ref,
      ServiceRequestStatus.awaitingTenantConfirmation,
      completionComments: comments,
    );
  }

  Future<void> _proposeAppointment(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: assignment.appointmentAt ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (date == null || !context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: assignment.appointmentAt == null
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(assignment.appointmentAt!),
    );
    if (time == null || !context.mounted) return;
    final proposedAt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    await ref
        .read(technicianAssignmentRepositoryProvider)
        .proposeAppointmentChange(assignment.id, proposedAt);
    if (!context.mounted) return;
    ref.invalidate(technicianAssignmentsProvider);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.proposalSaved)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignment = this.assignment;
    final l10n = context.l10n;
    final localizations = MaterialLocalizations.of(context);
    final isAwaitingTenant =
        assignment.awaitingTenantConfirmation ||
        assignment.status == ServiceRequestStatus.awaitingTenantConfirmation;
    final isClosed = assignment.status == ServiceRequestStatus.closed;
    final hasProposal = assignment.proposedAppointmentAt != null;
    return Scaffold(
      appBar: AppBar(title: Text(assignment.requestNumber)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (assignment.isSample)
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.sampleAssignmentNotice),
            ),
          Text(
            '${localizedServiceCategory(l10n, assignment.category)} · ${localizedServiceType(l10n, assignment.subcategory)}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _DetailRow(label: l10n.request, value: assignment.description),
          _DetailRow(
            label: l10n.address,
            value: assignment.location ?? l10n.locationUnavailable,
          ),
          _DetailRow(
            label: l10n.scheduledTime,
            value: assignment.appointmentAt == null
                ? l10n.appointmentNotScheduled
                : _formatDateTime(localizations, assignment.appointmentAt!),
          ),
          _DetailRow(
            label: l10n.requestStatus,
            value: isAwaitingTenant
                ? l10n.workCompletedAwaitingTenant
                : localizedStatus(l10n, assignment.status.name),
          ),
          if (assignment.completionComments != null)
            _DetailRow(
              label: l10n.closingComments,
              value: assignment.completionComments!,
            ),
          if (hasProposal) ...[
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.appointmentChangeProposal,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDateTime(
                        localizations,
                        assignment.proposedAppointmentAt!,
                      ),
                    ),
                    Text(
                      '${l10n.tenant}: ${assignment.tenantApprovedAppointmentChange ? l10n.approved : l10n.pending}',
                    ),
                    Text(
                      '${l10n.administrator}: ${assignment.adminApprovedAppointmentChange ? l10n.approved : l10n.pending}',
                    ),
                    const SizedBox(height: 4),
                    Text(l10n.appointmentUnchangedUntilBothApprove),
                  ],
                ),
              ),
            ),
          ],
          if (isAwaitingTenant)
            Card(
              child: ListTile(
                leading: const Icon(Icons.hourglass_top),
                title: Text(l10n.statusAwaitingTenantConfirmation),
                subtitle: Text(l10n.tenantConfirmationClosesRequest),
              ),
            ),
          if (!isAwaitingTenant && !isClosed) ...[
            const SizedBox(height: 20),
            if (assignment.status == ServiceRequestStatus.assigned)
              FilledButton.icon(
                key: const Key('accept-assignment'),
                onPressed: () =>
                    _setStatus(context, ref, ServiceRequestStatus.accepted),
                icon: const Icon(Icons.check),
                label: Text(l10n.acceptAssignment),
              ),
            if (assignment.status == ServiceRequestStatus.accepted ||
                assignment.status == ServiceRequestStatus.reopened)
              FilledButton.icon(
                key: const Key('start-work'),
                onPressed: () =>
                    _setStatus(context, ref, ServiceRequestStatus.inProgress),
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.startWork),
              ),
            if (assignment.status == ServiceRequestStatus.inProgress) ...[
              OutlinedButton.icon(
                key: const Key('propose-appointment'),
                onPressed: () => _proposeAppointment(context, ref),
                icon: const Icon(Icons.schedule),
                label: Text(l10n.proposeNewTime),
              ),
              FilledButton.icon(
                key: const Key('complete-work'),
                onPressed: () => _completeWork(context, ref),
                icon: const Icon(Icons.task_alt),
                label: Text(l10n.markWorkComplete),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 2),
        Text(value),
      ],
    ),
  );
}

String _formatDateTime(MaterialLocalizations localizations, DateTime value) =>
    '${localizations.formatMediumDate(value)} ${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(value))}';
