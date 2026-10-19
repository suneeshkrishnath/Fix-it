import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../l10n/app_localizations_extension.dart';
import '../../../../l10n/service_localization.dart';
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
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.serviceHistory),
        actions: [
          if (_hasFilters)
            IconButton(
              tooltip: l10n.clearFilters,
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
            child: Text(l10n.couldNotLoadHistory(error.toString())),
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
                      decoration: InputDecoration(
                        labelText: l10n.filterCategory,
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(l10n.allCategories),
                        ),
                        ...allServiceGroups.map(
                          (group) => DropdownMenuItem<String?>(
                            value: group.name,
                            child: Text(
                              localizedServiceCategory(l10n, group.name),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) => setState(() => _category = value),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<ServiceRequestStatus?>(
                      key: const Key('history-status-filter'),
                      initialValue: _status,
                      decoration: InputDecoration(
                        labelText: l10n.filterStatus,
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: [
                        DropdownMenuItem<ServiceRequestStatus?>(
                          value: null,
                          child: Text(l10n.allStatuses),
                        ),
                        ...ServiceRequestStatus.values.map(
                          (status) => DropdownMenuItem<ServiceRequestStatus?>(
                            value: status,
                            child: Text(localizedStatus(l10n, status.name)),
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
                              ? l10n.filterDateRange
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
                              ? l10n.noServiceHistory
                              : l10n.noMatchingRequests,
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
      title: Text(
        '${request.requestNumber} · ${localizedServiceCategory(context.l10n, request.category)}',
      ),
      subtitle: Text(
        '${localizedServiceType(context.l10n, request.subcategory)} · ${localizations.formatMediumDate(request.createdAt)}\n${localizedStatus(context.l10n, request.status.name)} · ${_costLabel(context, request.estimatedCost)}',
      ),
      isThreeLine: true,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

String _costLabel(BuildContext context, double? cost) => cost == null
    ? context.l10n.costNotRecorded
    : context.l10n.recordedCost(cost.toStringAsFixed(2));
