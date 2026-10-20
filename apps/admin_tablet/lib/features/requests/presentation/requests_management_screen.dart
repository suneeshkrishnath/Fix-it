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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        request.requestNumber,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AdminTheme.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _StatusLabel(status: request.status),
                  ],
                ),
                const SizedBox(height: 12),
                _RequestFacts(request: request),
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
