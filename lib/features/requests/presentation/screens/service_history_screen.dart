import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../domain/models/service_catalog.dart';
import '../../domain/models/service_request_filters.dart';
import '../../domain/models/service_request.dart';
import '../providers/service_request_providers.dart';

class ServiceHistoryScreen extends ConsumerStatefulWidget {
  const ServiceHistoryScreen({super.key});

  @override
  ConsumerState<ServiceHistoryScreen> createState() =>
      _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends ConsumerState<ServiceHistoryScreen> {
  String? _category;
  ServiceRequestStatus? _status;
  DateTimeRange? _dateRange;

  bool get _hasFilters =>
      _category != null || _status != null || _dateRange != null;

  Future<void> _selectDateRange() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: now,
      initialDateRange: _dateRange,
    );
    if (range != null && mounted) setState(() => _dateRange = range);
  }

  @override
  Widget build(BuildContext context) {
    final requests = ref.watch(serviceRequestsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service history'),
        actions: [
          if (_hasFilters)
            IconButton(
              tooltip: 'Clear filters',
              onPressed: () => setState(() {
                _category = null;
                _status = null;
                _dateRange = null;
              }),
              icon: const Icon(Icons.filter_alt_off_outlined),
            ),
        ],
      ),
      body: requests.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Could not load service history: $error'),
          ),
        ),
        data: (items) {
          final filtered =
              filterServiceRequests(
                items,
                category: _category,
                status: _status,
                startDate: _dateRange?.start,
                endDate: _dateRange?.end,
              )..sort(
                (first, second) => second.createdAt.compareTo(first.createdAt),
              );
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  children: [
                    DropdownButtonFormField<String?>(
                      key: const Key('history-category-filter'),
                      initialValue: _category,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('All categories'),
                        ),
                        ...allServiceGroups.map(
                          (group) => DropdownMenuItem<String?>(
                            value: group.name,
                            child: Text(group.name),
                          ),
                        ),
                      ],
                      onChanged: (value) => setState(() => _category = value),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<ServiceRequestStatus?>(
                      key: const Key('history-status-filter'),
                      initialValue: _status,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: [
                        const DropdownMenuItem<ServiceRequestStatus?>(
                          value: null,
                          child: Text('All statuses'),
                        ),
                        ...ServiceRequestStatus.values.map(
                          (status) => DropdownMenuItem<ServiceRequestStatus?>(
                            value: status,
                            child: Text(_statusLabel(status)),
                          ),
                        ),
                      ],
                      onChanged: (value) => setState(() => _status = value),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        key: const Key('history-date-filter'),
                        onPressed: _selectDateRange,
                        icon: const Icon(Icons.date_range_outlined),
                        label: Text(
                          _dateRange == null
                              ? 'Filter by date range'
                              : '${MaterialLocalizations.of(context).formatMediumDate(_dateRange!.start)} – ${MaterialLocalizations.of(context).formatMediumDate(_dateRange!.end)}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          items.isEmpty
                              ? 'No service history yet.'
                              : 'No requests match these filters.',
                        ),
                      )
                    : ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) => _HistoryTile(
                          request: filtered[index],
                          onTap: () => context.push(
                            AppRoutes.requestDetails(filtered[index].id),
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.request, required this.onTap});

  final ServiceRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return ListTile(
      key: Key('history-${request.id}'),
      title: Text('${request.requestNumber} · ${request.category}'),
      subtitle: Text(
        '${request.subcategory} · ${localizations.formatMediumDate(request.createdAt)}\n${_statusLabel(request.status)} · ${_costLabel(request.estimatedCost)}',
      ),
      isThreeLine: true,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
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

String _costLabel(double? cost) =>
    cost == null ? 'Cost not recorded' : 'Cost: ${cost.toStringAsFixed(2)}';
