import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations_extension.dart';
import '../../../../l10n/service_localization.dart';
import '../../domain/models/closed_case.dart';
import '../providers/closed_case_providers.dart';

class ClosedCasesScreen extends ConsumerWidget {
  const ClosedCasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cases = ref.watch(closedCasesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.closedCases)),
      body: cases.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l10n.couldNotLoadClosedCases(error.toString())),
          ),
        ),
        data: (items) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(l10n.sampleDataNotice,
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            for (final item in items) _ClosedCaseCard(item: item),
          ],
        ),
      ),
    );
  }
}

class _ClosedCaseCard extends StatelessWidget {
  const _ClosedCaseCard({required this.item});

  final ClosedCase item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dates = MaterialLocalizations.of(context);
    final rows = [
      (l10n.raisedOn, dates.formatMediumDate(item.raisedOn)),
      (l10n.approvedByManager, item.approvedBy),
      (l10n.technicianName, item.technician.name),
      (
        l10n.appointment,
        '${dates.formatMediumDate(item.appointmentAt)} '
            '${dates.formatTimeOfDay(TimeOfDay.fromDateTime(item.appointmentAt))}'
      ),
      (l10n.fixDate, dates.formatMediumDate(item.fixedOn)),
      (l10n.closingComments, item.closingComments),
    ];
    return Card(
      child: ExpansionTile(
        key: Key('closed-case-${item.id}'),
        title: Text(
          '${item.requestNumber} · ${localizedServiceCategory(l10n, item.category)}',
        ),
        subtitle: Text(localizedServiceType(l10n, item.subcategory)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.bodySmall),
                  Text(value),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
