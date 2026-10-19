import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../l10n/app_localizations_extension.dart';
import '../../../../l10n/service_localization.dart';
import '../../domain/models/service_catalog.dart';
import '../../domain/models/service_request.dart';
import '../providers/service_request_providers.dart';

class CreateServiceRequestScreen extends ConsumerStatefulWidget {
  const CreateServiceRequestScreen({super.key});

  @override
  ConsumerState<CreateServiceRequestScreen> createState() =>
      _CreateServiceRequestScreenState();
}

class _CreateServiceRequestScreenState
    extends ConsumerState<CreateServiceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String _category = allServiceGroups.first.name;
  String _subcategory = allServiceGroups.first.services.first;
  ServicePriority _priority = ServicePriority.normal;
  DateTime? _preferredVisitAt;
  bool _isSubmitting = false;

  ServiceGroup get _selectedGroup =>
      allServiceGroups.firstWhere((group) => group.name == _category);

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _chooseVisitTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _preferredVisitAt ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_preferredVisitAt ?? now),
    );
    if (time == null || !mounted) return;
    setState(() {
      _preferredVisitAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      final request = await ref
          .read(serviceRequestsProvider.notifier)
          .createRequest(
            category: _category,
            subcategory: _subcategory,
            description: _descriptionController.text.trim(),
            priority: _priority,
            preferredVisitAt: _preferredVisitAt,
          );
      if (mounted) context.push(AppRoutes.requestSubmitted, extra: request);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.createServiceRequest)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              DropdownButtonFormField<String>(
                key: const Key('request-category'),
                initialValue: _category,
                decoration: InputDecoration(
                  labelText: l10n.serviceCategory,
                  border: OutlineInputBorder(),
                ),
                items: allServiceGroups
                    .map((group) => DropdownMenuItem(
                          value: group.name,
                          child: Text(localizedServiceCategory(l10n, group.name)),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _category = value;
                    _subcategory = _selectedGroup.services.first;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: const Key('request-subcategory'),
                initialValue: _subcategory,
                decoration: InputDecoration(
                  labelText: l10n.serviceType,
                  border: OutlineInputBorder(),
                ),
                items: _selectedGroup.services
                    .map((service) => DropdownMenuItem(
                          value: service,
                          child: Text(localizedServiceType(l10n, service)),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _subcategory = value);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('request-description'),
                controller: _descriptionController,
                minLines: 3,
                maxLines: 6,
                maxLength: 1000,
                decoration: InputDecoration(
                  labelText: l10n.describeIssue,
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? l10n.descriptionRequired
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ServicePriority>(
                key: const Key('request-priority'),
                initialValue: _priority,
                decoration: InputDecoration(
                  labelText: l10n.priority,
                  border: OutlineInputBorder(),
                ),
                items: ServicePriority.values
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(localizedPriority(l10n, priority.name)),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _priority = value);
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _chooseVisitTime,
                icon: const Icon(Icons.calendar_month_outlined),
                label: Text(
                  _preferredVisitAt == null
                      ? l10n.choosePreferredVisit
                      : l10n.preferredVisit(
                          MaterialLocalizations.of(context)
                              .formatMediumDate(_preferredVisitAt!),
                          TimeOfDay.fromDateTime(_preferredVisitAt!).format(context),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : Text(l10n.submitRequest),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class RequestSubmittedScreen extends StatelessWidget {
  const RequestSubmittedScreen({required this.request, super.key});

  final ServiceRequest request;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.requestSubmitted)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.requestNumberSubmitted(request.requestNumber),
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${localizedServiceCategory(l10n, request.category)} · ${localizedServiceType(l10n, request.subcategory)}',
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go(AppRoutes.dashboard),
                child: Text(l10n.returnToDashboard),
              ),
            ],
          ),
        ),
      ),
    );
  }
}