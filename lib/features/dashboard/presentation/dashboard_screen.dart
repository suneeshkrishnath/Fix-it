import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../l10n/app_localizations_extension.dart';
import '../../auth/presentation/providers/auth_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resident = ref.watch(authControllerProvider).resident;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          IconButton(
            tooltip: l10n.signOut,
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) context.go(AppRoutes.login);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          Text(
            resident == null
                ? l10n.welcomeToFixIt
                : l10n.welcomeResident(resident.name),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (resident != null) ...[
            const SizedBox(height: 4),
            Text(l10n.apartmentValue(resident.apartmentNumber)),
          ],
          const SizedBox(height: 28),
          Text(l10n.serviceRequests, style: Theme.of(context).textTheme.titleMedium),
          _DashboardAction(
            key: const Key('create-request-action'),
            icon: Icons.add_circle_outline,
            title: l10n.createServiceRequest,
            subtitle: l10n.reportMaintenanceIssue,
            onTap: () => context.push(AppRoutes.createRequest),
          ),
          _DashboardAction(
            key: const Key('my-requests-action'),
            icon: Icons.assignment_outlined,
            title: l10n.myRequests,
            subtitle: l10n.trackOpenRequests,
            onTap: () => context.push(AppRoutes.requests),
          ),
          _DashboardAction(
            key: const Key('history-action'),
            icon: Icons.history,
            title: l10n.serviceHistory,
            subtitle: l10n.reviewCompletedServices,
            onTap: () => context.push(AppRoutes.history),
          ),
          const Divider(),
          Text(l10n.apartmentSection, style: Theme.of(context).textTheme.titleMedium),
          _DashboardAction(
            key: const Key('move-out-action'),
            icon: Icons.exit_to_app,
            title: l10n.moveOutRequest,
            subtitle: l10n.startMoveOutRequest,
            onTap: () => context.push(AppRoutes.moveOut),
          ),
          _DashboardAction(
            key: const Key('profile-action'),
            icon: Icons.person_outline,
            title: l10n.residentProfile,
            subtitle: l10n.viewResidentDetails,
            onTap: () => context.push(AppRoutes.profile),
          ),
        ],
      ),
    );
  }
}

class _DashboardAction extends StatelessWidget {
  const _DashboardAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}