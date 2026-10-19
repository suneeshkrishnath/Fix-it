import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations_extension.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/models/move_out_request.dart';
import '../providers/move_out_providers.dart';

class MoveOutScreen extends ConsumerWidget {
  const MoveOutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final requests = ref.watch(moveOutRequestsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.moveOutRequest)),
      body: requests.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l10n.couldNotLoadMoveOut(error.toString())),
          ),
        ),
        data: (items) => items.isEmpty
            ? const _MoveOutForm()
            : _MoveOutTracking(request: items.first),
      ),
    );
  }
}

class _MoveOutForm extends ConsumerStatefulWidget {
  const _MoveOutForm();

  @override
  ConsumerState<_MoveOutForm> createState() => _MoveOutFormState();
}

class _MoveOutFormState extends ConsumerState<_MoveOutForm> {
  final _formKey = GlobalKey<FormState>();
  late final _contactController = TextEditingController(
    text: ref.read(authControllerProvider).resident?.phoneNumber,
  );
  final _reasonController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _moveOutDate;
  bool _showDateError = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contactController.dispose();
    _reasonController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _chooseDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _moveOutDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (date != null && mounted) {
      setState(() {
        _moveOutDate = date;
        _showDateError = false;
      });
    }
  }

  Future<void> _submit() async {
    final valid = _formKey.currentState!.validate();
    if (_moveOutDate == null) setState(() => _showDateError = true);
    if (!valid || _moveOutDate == null) return;
    setState(() => _isSubmitting = true);
    try {
      await ref.read(moveOutRequestsProvider.notifier).submit(
            moveOutDate: _moveOutDate!,
            reason: _reasonController.text.trim(),
            contactNumber: _contactController.text.trim(),
            forwardingAddress: _addressController.text.trim(),
            notes: _notesController.text.trim(),
          );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String? _required(String? value, String message) =>
      value == null || value.trim().isEmpty ? message : null;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          OutlinedButton.icon(
            key: const Key('moveout-date'),
            onPressed: _chooseDate,
            icon: const Icon(Icons.calendar_month_outlined),
            label: Text(
              _moveOutDate == null
                  ? l10n.chooseMoveOutDate
                  : MaterialLocalizations.of(context)
                      .formatMediumDate(_moveOutDate!),
            ),
          ),
          if (_showDateError)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l10n.moveOutDateRequired,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('moveout-reason'),
            controller: _reasonController,
            decoration: InputDecoration(
              labelText: l10n.moveOutReason,
              border: const OutlineInputBorder(),
            ),
            validator: (value) => _required(value, l10n.moveOutReasonRequired),
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('moveout-contact'),
            controller: _contactController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: l10n.contactNumber,
              border: const OutlineInputBorder(),
            ),
            validator: (value) => _required(value, l10n.enterPhoneNumber),
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('moveout-address'),
            controller: _addressController,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: l10n.forwardingAddress,
              border: const OutlineInputBorder(),
            ),
            validator: (value) =>
                _required(value, l10n.forwardingAddressRequired),
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('moveout-notes'),
            controller: _notesController,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: l10n.notesOptional,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            key: const Key('moveout-submit'),
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const CircularProgressIndicator()
                : Text(l10n.submitMoveOutRequest),
          ),
        ],
      ),
    );
  }
}

class _MoveOutTracking extends StatelessWidget {
  const _MoveOutTracking({required this.request});

  final MoveOutRequest request;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dates = MaterialLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final currentIndex = MoveOutStatus.values.indexOf(request.status);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(l10n.moveOutSubmittedTitle,
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text('${l10n.moveOutDate}: ${dates.formatMediumDate(request.moveOutDate)}'),
        Text('${l10n.moveOutReason}: ${request.reason}'),
        Text('${l10n.contactNumber}: ${request.contactNumber}'),
        Text('${l10n.forwardingAddress}: ${request.forwardingAddress}'),
        if (request.notes.isNotEmpty)
          Text('${l10n.notesOptional}: ${request.notes}'),
        const SizedBox(height: 24),
        Text(l10n.requestStatus, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        for (var index = 0; index < MoveOutStatus.values.length; index++)
          ListTile(
            key: Key('moveout-step-${MoveOutStatus.values[index].name}'),
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              index < currentIndex
                  ? Icons.check_circle
                  : index == currentIndex
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
              color: index <= currentIndex ? colors.primary : colors.outline,
            ),
            title: Text(_moveOutStatusLabel(l10n, MoveOutStatus.values[index])),
          ),
        const SizedBox(height: 8),
        Text(l10n.statusSavedOnDevice,
            style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

String _moveOutStatusLabel(AppLocalizations l10n, MoveOutStatus status) =>
    switch (status) {
      MoveOutStatus.submitted => l10n.statusSubmitted,
      MoveOutStatus.review => l10n.moveOutStatusReview,
      MoveOutStatus.inspectionScheduled => l10n.moveOutStatusInspectionScheduled,
      MoveOutStatus.inspectionCompleted => l10n.moveOutStatusInspectionCompleted,
      MoveOutStatus.approved => l10n.moveOutStatusApproved,
      MoveOutStatus.closed => l10n.moveOutStatusClosed,
    };
