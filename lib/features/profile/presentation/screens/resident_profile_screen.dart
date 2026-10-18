import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations_extension.dart';
import '../../domain/models/resident_profile.dart';
import '../providers/profile_providers.dart';

class ResidentProfileScreen extends ConsumerWidget {
  const ResidentProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profile = ref.watch(residentProfileProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.residentProfile)),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l10n.couldNotLoadProfile(error.toString())),
          ),
        ),
        data: (data) =>
            data == null ? const SizedBox.shrink() : _ProfileBody(profile: data),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.profile});

  final ResidentProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dates = MaterialLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.sampleDataNotice, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        _InfoSection(
          key: const Key('profile-tenant'),
          title: l10n.tenantDetails,
          rows: [
            (l10n.fullName, profile.tenantName),
            (l10n.phoneNumber, profile.phoneNumber),
            (l10n.email, profile.email),
            (l10n.emiratesId, profile.emiratesId),
          ],
        ),
        _InfoSection(
          key: const Key('profile-apartment'),
          title: l10n.apartmentDetails,
          rows: [
            (l10n.apartmentNumber, profile.apartmentNumber),
            (l10n.towerNumber, profile.towerNumber),
            (l10n.floor, profile.floor),
            (l10n.address, profile.address),
          ],
        ),
        _InfoSection(
          key: const Key('profile-tenancy'),
          title: l10n.tenancyDetails,
          rows: [
            (l10n.tenancyStart, dates.formatMediumDate(profile.tenancyStart)),
            (l10n.tenancyEnd, dates.formatMediumDate(profile.tenancyEnd)),
            (l10n.annualRent, profile.annualRent),
            (l10n.paymentFrequency, profile.paymentFrequency),
            (l10n.securityDeposit, profile.securityDeposit),
          ],
        ),
        _InfoSection(
          key: const Key('profile-contract'),
          title: l10n.contractDetails,
          rows: [
            (l10n.contractNumber, profile.contractNumber),
            (l10n.landlord, profile.landlord),
            (l10n.contractIssued,
                dates.formatMediumDate(profile.contractIssuedOn)),
            (l10n.contractExpires,
                dates.formatMediumDate(profile.contractExpiresOn)),
          ],
        ),
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.rows, super.key});

  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final (label, value) in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: textTheme.bodySmall),
                    Text(value, style: textTheme.bodyLarge),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
