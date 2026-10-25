import 'package:flutter/material.dart';

import '../../../admin_theme.dart';
import '../../technicians/data/repositories/mock_technician_management_repository.dart';
import '../../technicians/domain/models/technician_records.dart';
import '../data/repositories/mock_admin_request_repository.dart';
import '../domain/models/admin_request_records.dart';

class RequestsManagementScreen extends StatefulWidget {
  const RequestsManagementScreen({
    required this.requests,
    required this.technicians,
    super.key,
  });

  final MockAdminRequestRepository requests;
  final MockTechnicianManagementRepository technicians;

  @override
  State<RequestsManagementScreen> createState() =>
      _RequestsManagementScreenState();
}

class _RequestsManagementScreenState extends State<RequestsManagementScreen> {
  String _search = '';
  WorkRequestStatus? _statusFilter;
  String? _selectedRequestId;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.requests,
    builder: (context, _) => Scaffold(
      appBar: AppBar(
        title: const Text('Request queue'),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: _LocalDataBadge(),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final query = _search.trim().toLowerCase();
          final records = widget.requests.requests.where((request) {
            final matchesQuery =
                query.isEmpty ||
                request.requestNumber.toLowerCase().contains(query) ||
                request.tenantName.toLowerCase().contains(query) ||
                request.apartment.toLowerCase().contains(query) ||
                request.category.toLowerCase().contains(query);
            return matchesQuery &&
                (_statusFilter == null || request.status == _statusFilter);
          }).toList();
          final selected =
              records
                  .where((request) => request.id == _selectedRequestId)
                  .firstOrNull ??
              widget.requests.requests
                  .where((request) => request.id == _selectedRequestId)
                  .firstOrNull ??
              (records.isEmpty ? null : records.first);
          if (_selectedRequestId == null && selected != null) {
            _selectedRequestId = selected.id;
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Review and assign work orders',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Text(
                      '${widget.requests.requests.length} sample requests',
                      style: Theme.of(context).textTheme.labelLarge
                          ?.copyWith(color: AdminTheme.teal),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const Key('request-search'),
                        onChanged: (value) => setState(() => _search = value),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search request, tenant, unit, or service',
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: constraints.maxWidth < 680 ? 160 : 210,
                      child: DropdownButtonFormField<WorkRequestStatus?>(
                        key: const Key('request-status-filter'),
                        initialValue: _statusFilter,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          isDense: true,
                        ),
                        items: [
                          const DropdownMenuItem<WorkRequestStatus?>(
                            value: null,
                            child: Text('All statuses'),
                          ),
                          ...WorkRequestStatus.values.map(
                            (status) => DropdownMenuItem<WorkRequestStatus?>(
                              value: status,
                              child: Text(status.label),
                            ),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => _statusFilter = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth < 760 ? 260 : 330,
                        child: _requestList(records, selected),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _requestDetails(selected)),
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

  Widget _requestList(
    List<AdminRequestRecord> records,
    AdminRequestRecord? selected,
  ) => Card(
    clipBehavior: Clip.antiAlias,
    child: records.isEmpty
        ? const Center(child: Text('No requests match these filters.'))
        : ListView.separated(
            itemCount: records.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final request = records[index];
              return ListTile(
                key: Key('request-row-${request.requestNumber}'),
                selected: request.id == selected?.id,
                selectedTileColor: AdminTheme.tealLight,
                onTap: () => setState(() => _selectedRequestId = request.id),
                title: Text(
                  request.requestNumber,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${request.tenantName} · ${request.apartment}\n${request.category} · ${request.priority}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                isThreeLine: true,
              );
            },
          ),
  );

  Widget _requestDetails(AdminRequestRecord? request) => Card(
    child: request == null
        ? const Center(child: Text('Select a request to review.'))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.requestNumber,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AdminTheme.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _StatusLabel(status: request.status),
                  ],
                ),
                const SizedBox(height: 12),
                _RequestFacts(request: request),
                if (request.scheduledAt != null ||
                    request.status == WorkRequestStatus.assigned) ...[
                  const SizedBox(height: 14),
                  _appointmentSection(request),
                ],
                if (_hasWorkLifecycle(request.status)) ...[
                  const SizedBox(height: 14),
                  _workStatusSection(request),
                ],
                const SizedBox(height: 12),
                Text(
                  request.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (request.assignedTechnicianName != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Assigned technician: ${request.assignedTechnicianName}',
                    key: const Key('assigned-technician'),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
                const SizedBox(height: 14),
                _decisionActions(request),
                const Divider(height: 26),
                Text(
                  'Status history',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                for (final event in request.history.reversed)
                  _HistoryEntry(event: event),
              ],
            ),
          ),
  );

  Widget _workStatusSection(AdminRequestRecord request) {
    final reopenWindowOpen =
        request.closedAt != null &&
        DateTime.now().isBefore(
          request.closedAt!.add(const Duration(hours: 24)),
        );
    final actions = switch (request.status) {
      WorkRequestStatus.assigned || WorkRequestStatus.reopened => [
        _workAction(
          key: 'work-mark-travelling',
          label: 'Mark travelling',
          icon: Icons.directions_car_outlined,
          onPressed: () => widget.requests.markTravelling(request.id),
        ),
      ],
      WorkRequestStatus.travelling => [
        _workAction(
          key: 'work-start',
          label: 'Start work',
          icon: Icons.play_arrow,
          onPressed: () => widget.requests.startWork(request.id),
        ),
      ],
      WorkRequestStatus.workStarted => [
        _workAction(
          key: 'work-block',
          label: 'Block work',
          icon: Icons.pause_circle_outline,
          onPressed: () => _blockWork(request),
          outlined: true,
        ),
        _workAction(
          key: 'work-complete',
          label: 'Record completion',
          icon: Icons.task_alt,
          onPressed: () => _completeWork(request),
        ),
      ],
      WorkRequestStatus.workBlocked => [
        _workAction(
          key: 'work-resume',
          label: 'Resume work',
          icon: Icons.play_arrow,
          onPressed: () => widget.requests.resumeWork(request.id),
        ),
      ],
      WorkRequestStatus.awaitingTenantConfirmation => [
        _workAction(
          key: 'tenant-accept-completion',
          label: 'Simulate tenant acceptance',
          icon: Icons.thumb_up_outlined,
          onPressed: () => _recordTenantCompletion(request, accepted: true),
          outlined: true,
        ),
        _workAction(
          key: 'tenant-reject-completion',
          label: 'Simulate tenant rejection',
          icon: Icons.thumb_down_outlined,
          onPressed: () => _recordTenantCompletion(request, accepted: false),
          outlined: true,
        ),
      ],
      WorkRequestStatus.awaitingAdminClosureApproval => [
        _workAction(
          key: 'admin-approve-closure',
          label: 'Approve and close',
          icon: Icons.lock_outline,
          onPressed: () => _recordClosureDecision(request, approved: true),
        ),
        _workAction(
          key: 'admin-reject-closure',
          label: 'Reject completion',
          icon: Icons.undo,
          onPressed: () => _recordClosureDecision(request, approved: false),
          outlined: true,
        ),
      ],
      WorkRequestStatus.closed => [
        if (reopenWindowOpen)
          _workAction(
            key: 'tenant-request-reopen',
            label: 'Simulate tenant reopen',
            icon: Icons.lock_open_outlined,
            onPressed: () => _requestReopen(request),
            outlined: true,
          )
        else
          const Chip(
            avatar: Icon(Icons.timer_off_outlined, size: 16),
            label: Text('24-hour reopen window expired'),
          ),
      ],
      WorkRequestStatus.reopenPendingReview => [
        _workAction(
          key: 'admin-accept-reopen',
          label: 'Accept reopening',
          icon: Icons.lock_open_outlined,
          onPressed: () => _reviewReopen(request, accepted: true),
        ),
        _workAction(
          key: 'admin-reject-reopen',
          label: 'Reject reopening',
          icon: Icons.block_outlined,
          onPressed: () => _reviewReopen(request, accepted: false),
          outlined: true,
        ),
      ],
      _ => <Widget>[],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Text('Work status', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        if (request.travellingAt != null)
          Text('Travelling: ${_formatDateTime(request.travellingAt!)}'),
        if (request.workStartedAt != null)
          Text('Work started: ${_formatDateTime(request.workStartedAt!)}'),
        if (request.status == WorkRequestStatus.workBlocked)
          Text('Block reason: ${request.blockReason}'),
        if (request.closedAt != null) ...[
          Text('Officially closed: ${_formatDateTime(request.closedAt!)}'),
          if (request.status == WorkRequestStatus.closed && reopenWindowOpen)
            Text(
              'Reopen available until ${_formatDateTime(request.closedAt!.add(const Duration(hours: 24)))}',
            ),
        ],
        if (request.reopenReason != null)
          Text('Reopen reason: ${request.reopenReason}'),
        for (var index = 0; index < request.completions.length; index++)
          _CompletionSummary(
            completion: request.completions[index],
            attempt: index + 1,
          ),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: actions),
        const Divider(),
      ],
    );
  }

  Widget _workAction({
    required String key,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool outlined = false,
  }) {
    final iconWidget = Icon(icon);
    final labelWidget = Text(label);
    return outlined
        ? OutlinedButton.icon(
            key: Key(key),
            onPressed: onPressed,
            icon: iconWidget,
            label: labelWidget,
          )
        : FilledButton.icon(
            key: Key(key),
            onPressed: onPressed,
            icon: iconWidget,
            label: labelWidget,
          );
  }

  Future<void> _blockWork(AdminRequestRecord request) async {
    final reason = await _reasonDialog(
      title: 'Block work',
      label: 'Block reason and details',
    );
    if (reason == null || !mounted) return;
    widget.requests.blockWork(request.id, reason);
  }

  Future<void> _completeWork(AdminRequestRecord request) async {
    final comments = await _reasonDialog(
      title: 'Record work completion',
      label: 'Completion comments',
    );
    if (comments == null || !mounted) return;
    widget.requests.completeWork(request.id, comments);
  }

  Future<void> _recordTenantCompletion(
    AdminRequestRecord request, {
    required bool accepted,
  }) async {
    var reason = '';
    if (!accepted) {
      final response = await _reasonDialog(
        title: 'Tenant rejection',
        label: 'Reason work needs more attention',
      );
      if (response == null || !mounted) return;
      reason = response;
    }
    widget.requests.recordTenantCompletionDecision(
      request.id,
      accepted: accepted,
      reason: reason,
    );
  }

  Future<void> _recordClosureDecision(
    AdminRequestRecord request, {
    required bool approved,
  }) async {
    var reason = '';
    if (!approved) {
      final response = await _reasonDialog(
        title: 'Reject completion',
        label: 'Reason work cannot be closed',
      );
      if (response == null || !mounted) return;
      reason = response;
    }
    widget.requests.recordAdminClosureDecision(
      request.id,
      approved: approved,
      reason: reason,
    );
  }

  Future<void> _requestReopen(AdminRequestRecord request) async {
    final reason = await _reasonDialog(
      title: 'Simulate tenant reopen request',
      label: 'Reason for reopening',
    );
    if (reason == null || !mounted) return;
    widget.requests.requestReopen(request.id, reason);
  }

  Future<void> _reviewReopen(
    AdminRequestRecord request, {
    required bool accepted,
  }) async {
    var reason = '';
    if (!accepted) {
      final response = await _reasonDialog(
        title: 'Reject reopening',
        label: 'Reason for rejection',
      );
      if (response == null || !mounted) return;
      reason = response;
    }
    widget.requests.reviewReopenRequest(
      request.id,
      accepted: accepted,
      reason: reason,
    );
  }

  Widget _appointmentSection(AdminRequestRecord request) {
    final proposal = request.appointmentProposal;
    final rejected =
        proposal?.tenantDecision == AppointmentDecision.rejected ||
        proposal?.adminDecision == AppointmentDecision.rejected;
    final confirmed =
        proposal != null &&
        proposal.tenantDecision == AppointmentDecision.approved &&
        proposal.adminDecision == AppointmentDecision.approved;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Text('Appointment', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Text(
          request.scheduledAt == null
              ? 'No appointment scheduled'
              : 'Current: ${_formatDateTime(request.scheduledAt!)}',
          key: const Key('current-appointment'),
        ),
        if (proposal != null) ...[
          const SizedBox(height: 6),
          Text('Proposed: ${_formatDateTime(proposal.proposedAt)}'),
          Text('Reason: ${proposal.reason}'),
          Text('Tenant decision: ${_decisionLabel(proposal.tenantDecision)}'),
          Text('Admin decision: ${_decisionLabel(proposal.adminDecision)}'),
          if (confirmed)
            const Text('Both approved. Proposed appointment confirmed.'),
          if (rejected)
            const Text('Proposal declined. Existing appointment retained.'),
        ],
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (proposal == null || confirmed || rejected)
              OutlinedButton.icon(
                key: const Key('propose-appointment-action'),
                onPressed: () => _proposeAppointment(request),
                icon: const Icon(Icons.event_outlined),
                label: const Text('Propose appointment change'),
              ),
            if (proposal != null && !confirmed && !rejected) ...[
              if (proposal.tenantDecision == AppointmentDecision.pending) ...[
                OutlinedButton(
                  key: const Key('tenant-approve-appointment-action'),
                  onPressed: () => _recordAppointmentDecision(
                    request,
                    byTenant: true,
                    decision: AppointmentDecision.approved,
                  ),
                  child: const Text('Simulate tenant approval'),
                ),
                OutlinedButton(
                  key: const Key('tenant-reject-appointment-action'),
                  onPressed: () => _recordAppointmentDecision(
                    request,
                    byTenant: true,
                    decision: AppointmentDecision.rejected,
                  ),
                  child: const Text('Simulate tenant rejection'),
                ),
              ],
              if (proposal.adminDecision == AppointmentDecision.pending) ...[
                FilledButton(
                  key: const Key('admin-approve-appointment-action'),
                  onPressed: () => _recordAppointmentDecision(
                    request,
                    byTenant: false,
                    decision: AppointmentDecision.approved,
                  ),
                  child: const Text('Approve proposed time'),
                ),
                OutlinedButton(
                  key: const Key('admin-reject-appointment-action'),
                  onPressed: () => _recordAppointmentDecision(
                    request,
                    byTenant: false,
                    decision: AppointmentDecision.rejected,
                  ),
                  child: const Text('Reject proposed time'),
                ),
              ],
            ],
          ],
        ),
        const Divider(),
      ],
    );
  }

  Future<void> _proposeAppointment(AdminRequestRecord request) async {
    final current = request.scheduledAt ?? DateTime.now();
    var selectedDate = DateTime.now().add(const Duration(days: 1));
    var selectedTime = TimeOfDay.fromDateTime(current);
    var reason = '';
    final formKey = GlobalKey<FormState>();
    final result =
        await showDialog<({DateTime date, TimeOfDay time, String reason})>(
          context: context,
          builder: (dialogContext) => StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
              title: const Text('Propose appointment change'),
              content: SizedBox(
                width: 480,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              key: const Key('appointment-date-picker'),
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                );
                                if (date != null) {
                                  setDialogState(() => selectedDate = date);
                                }
                              },
                              icon: const Icon(Icons.calendar_today_outlined),
                              label: Text(_formatDate(selectedDate)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              key: const Key('appointment-time-picker'),
                              onPressed: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: selectedTime,
                                );
                                if (time != null) {
                                  setDialogState(() => selectedTime = time);
                                }
                              },
                              icon: const Icon(Icons.schedule_outlined),
                              label: Text(selectedTime.format(context)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        key: const Key('appointment-proposal-reason-field'),
                        decoration: const InputDecoration(
                          labelText: 'Reason for change',
                        ),
                        maxLines: 2,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Enter a reason for the change.'
                            : null,
                        onChanged: (value) => reason = value,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  key: const Key('save-appointment-proposal'),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    Navigator.pop(dialogContext, (
                      date: selectedDate,
                      time: selectedTime,
                      reason: reason.trim(),
                    ));
                  },
                  child: const Text('Send proposal'),
                ),
              ],
            ),
          ),
        );
    if (result == null || !mounted) return;
    final proposedAt = DateTime(
      result.date.year,
      result.date.month,
      result.date.day,
      result.time.hour,
      result.time.minute,
    );
    widget.requests.proposeAppointmentChange(
      requestId: request.id,
      proposedAt: proposedAt,
      reason: result.reason,
    );
  }

  Future<void> _recordAppointmentDecision(
    AdminRequestRecord request, {
    required bool byTenant,
    required AppointmentDecision decision,
  }) async {
    var reason = '';
    if (decision == AppointmentDecision.rejected) {
      final response = await _reasonDialog(
        title: byTenant ? 'Simulate tenant rejection' : 'Reject proposed time',
        label: 'Reason for rejection',
      );
      if (response == null || !mounted) return;
      reason = response;
    }
    widget.requests.recordAppointmentDecision(
      requestId: request.id,
      byTenant: byTenant,
      decision: decision,
      reason: reason,
    );
  }

  Widget _decisionActions(AdminRequestRecord request) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: switch (request.status) {
      WorkRequestStatus.submitted => [
        FilledButton.icon(
          key: const Key('approve-request-action'),
          onPressed: () =>
              _recordDecision(request, WorkRequestStatus.readyToAssign),
          icon: const Icon(Icons.check),
          label: const Text('Approve'),
        ),
        OutlinedButton.icon(
          key: const Key('request-information-action'),
          onPressed: () =>
              _recordDecision(request, WorkRequestStatus.informationRequested),
          icon: const Icon(Icons.help_outline),
          label: const Text('Request information'),
        ),
        OutlinedButton.icon(
          key: const Key('reject-request-action'),
          onPressed: () => _recordDecision(request, WorkRequestStatus.rejected),
          icon: const Icon(Icons.block_outlined),
          label: const Text('Reject'),
        ),
      ],
      WorkRequestStatus.readyToAssign => [
        FilledButton.icon(
          key: const Key('assign-technician-action'),
          onPressed: () => _assignTechnician(request),
          icon: const Icon(Icons.person_add_alt_1),
          label: const Text('Assign technician'),
        ),
      ],
      WorkRequestStatus.assigned => [
        OutlinedButton.icon(
          key: const Key('reassign-technician-action'),
          onPressed: () => _assignTechnician(request),
          icon: const Icon(Icons.swap_horiz),
          label: const Text('Reassign'),
        ),
      ],
      WorkRequestStatus.informationRequested => [
        const Chip(
          avatar: Icon(Icons.hourglass_top, size: 16),
          label: Text('Waiting for resident information'),
        ),
      ],
      WorkRequestStatus.rejected => [
        const Chip(
          avatar: Icon(Icons.block_outlined, size: 16),
          label: Text('Review closed'),
        ),
      ],
      _ => <Widget>[],
    },
  );

  Future<void> _recordDecision(
    AdminRequestRecord request,
    WorkRequestStatus status,
  ) async {
    final reason = await _reasonDialog(
      title: switch (status) {
        WorkRequestStatus.readyToAssign => 'Approve request',
        WorkRequestStatus.informationRequested => 'Request information',
        WorkRequestStatus.rejected => 'Reject request',
        _ => 'Review request',
      },
      label: switch (status) {
        WorkRequestStatus.readyToAssign => 'Approval reason',
        WorkRequestStatus.informationRequested => 'Information needed',
        WorkRequestStatus.rejected => 'Rejection reason',
        _ => 'Reason',
      },
    );
    if (reason == null || !mounted) return;
    widget.requests.recordDecision(
      requestId: request.id,
      status: status,
      reason: reason,
    );
  }

  Future<void> _assignTechnician(AdminRequestRecord request) async {
    final activeTechnicians = widget.technicians.technicians
        .where((technician) => technician.status == AccountStatus.active)
        .toList();
    if (activeTechnicians.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active technicians are available.')),
      );
      return;
    }
    var technicianId = request.assignedTechnicianId;
    var reason = '';
    final formKey = GlobalKey<FormState>();
    final reassignment = request.status == WorkRequestStatus.assigned;
    final result = await showDialog<({String technicianId, String reason})>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          scrollable: true,
          title: Text(reassignment ? 'Reassign request' : 'Assign request'),
          content: SizedBox(
            width: 480,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    key: const Key('request-technician-field'),
                    initialValue:
                        activeTechnicians.any((item) => item.id == technicianId)
                        ? technicianId
                        : null,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Technician'),
                    items: [
                      for (final technician in activeTechnicians)
                        DropdownMenuItem(
                          value: technician.id,
                          child: Text(
                            '${technician.fullName} · ${technician.specialty}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    validator: (value) =>
                        value == null ? 'Select a technician.' : null,
                    onChanged: (value) =>
                        setDialogState(() => technicianId = value),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const Key('assignment-reason-field'),
                    decoration: InputDecoration(
                      labelText: reassignment
                          ? 'Reassignment reason'
                          : 'Assignment note (optional)',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 2,
                    validator: (value) =>
                        reassignment && (value == null || value.trim().isEmpty)
                        ? 'Enter a reason for reassignment.'
                        : null,
                    onChanged: (value) => reason = value,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              key: const Key('save-request-assignment'),
              onPressed: () {
                if (!formKey.currentState!.validate() || technicianId == null) {
                  return;
                }
                Navigator.pop(dialogContext, (
                  technicianId: technicianId!,
                  reason: reason.trim(),
                ));
              },
              child: Text(reassignment ? 'Save reassignment' : 'Assign'),
            ),
          ],
        ),
      ),
    );
    if (result == null || !mounted) return;
    final technician = activeTechnicians.firstWhere(
      (item) => item.id == result.technicianId,
    );
    widget.requests.assignTechnician(
      requestId: request.id,
      technicianId: technician.id,
      technicianName: technician.fullName,
      reason: result.reason,
    );
  }

  Future<String?> _reasonDialog({
    required String title,
    required String label,
  }) => showDialog<String>(
    context: context,
    builder: (dialogContext) {
      var reason = '';
      final formKey = GlobalKey<FormState>();
      return AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 460,
          child: Form(
            key: formKey,
            child: TextFormField(
              key: const Key('request-decision-reason-field'),
              autofocus: true,
              maxLines: 3,
              decoration: InputDecoration(labelText: label),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter a reason to continue.'
                  : null,
              onChanged: (value) => reason = value,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const Key('save-request-decision'),
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(dialogContext, reason.trim());
            },
            child: const Text('Save decision'),
          ),
        ],
      );
    },
  );
}

class _RequestFacts extends StatelessWidget {
  const _RequestFacts({required this.request});

  final AdminRequestRecord request;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 16,
    runSpacing: 8,
    children: [
      _Fact(label: 'Resident', value: request.tenantName),
      _Fact(
        label: 'Apartment',
        value: '${request.building} · ${request.apartment}',
      ),
      _Fact(label: 'Service', value: request.category),
      _Fact(label: 'Priority', value: request.priority),
      _Fact(label: 'Submitted', value: _formatDateTime(request.createdAt)),
    ],
  );
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 160,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    ),
  );
}

class _HistoryEntry extends StatelessWidget {
  const _HistoryEntry({required this.event});

  final AdminRequestEvent event;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.history, size: 18, color: AdminTheme.teal),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '${event.actor} · ${_formatDateTime(event.occurredAt)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (event.technicianName != null)
                Text('Technician: ${event.technicianName}'),
              if (event.reason != null) Text('Reason: ${event.reason}'),
            ],
          ),
        ),
      ],
    ),
  );
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.status});

  final WorkRequestStatus status;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: status == WorkRequestStatus.rejected
          ? const Color(0xFFF8E7E4)
          : AdminTheme.tealLight,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      status.label,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
    ),
  );
}

class _CompletionSummary extends StatelessWidget {
  const _CompletionSummary({required this.completion, required this.attempt});

  final WorkCompletionRecord completion;
  final int attempt;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Completion attempt $attempt'),
        Text('Comments: ${completion.comments}'),
        Text('Elapsed work time: ${completion.elapsedWorkMinutes} min'),
        Text(
          'Tenant decision: ${_completionDecisionLabel(completion.tenantDecision)}',
        ),
        if (completion.tenantReason != null)
          Text('Tenant reason: ${completion.tenantReason}'),
        if (completion.adminApprovedAt != null)
          Text(
            'Admin approved: ${_formatDateTime(completion.adminApprovedAt!)}',
          ),
      ],
    ),
  );
}

class _LocalDataBadge extends StatelessWidget {
  const _LocalDataBadge();

  @override
  Widget build(BuildContext context) => const Chip(
    avatar: Icon(Icons.storage_outlined, size: 16),
    label: Text('LOCAL SAMPLE DATA'),
    visualDensity: VisualDensity.compact,
  );
}

String _formatDateTime(DateTime dateTime) {
  final local = dateTime.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$day/$month/${local.year} $hour:$minute';
}

String _formatDate(DateTime dateTime) {
  final month = dateTime.month.toString().padLeft(2, '0');
  final day = dateTime.day.toString().padLeft(2, '0');
  return '$day/$month/${dateTime.year}';
}

String _decisionLabel(AppointmentDecision decision) => switch (decision) {
  AppointmentDecision.pending => 'Pending',
  AppointmentDecision.approved => 'Approved',
  AppointmentDecision.rejected => 'Rejected',
};

String _completionDecisionLabel(CompletionDecision decision) =>
    switch (decision) {
      CompletionDecision.pending => 'Pending',
      CompletionDecision.accepted => 'Accepted',
      CompletionDecision.rejected => 'Rejected',
    };

bool _hasWorkLifecycle(WorkRequestStatus status) => switch (status) {
  WorkRequestStatus.assigned ||
  WorkRequestStatus.travelling ||
  WorkRequestStatus.workStarted ||
  WorkRequestStatus.workBlocked ||
  WorkRequestStatus.awaitingTenantConfirmation ||
  WorkRequestStatus.awaitingAdminClosureApproval ||
  WorkRequestStatus.closed ||
  WorkRequestStatus.reopenPendingReview ||
  WorkRequestStatus.reopened => true,
  _ => false,
};
