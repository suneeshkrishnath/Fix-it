import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../auth/presentation/providers/auth_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resident = ref.watch(authControllerProvider).resident;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fix-it'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
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
            'Welcome${resident == null ? '' : ', ${resident.name}'}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (resident != null) ...[
            const SizedBox(height: 4),
            Text('Apartment ${resident.apartmentNumber}'),
          ],
          const SizedBox(height: 28),
          Text('Service requests', style: Theme.of(context).textTheme.titleMedium),
          _DashboardAction(
            key: const Key('create-request-action'),
            icon: Icons.add_circle_outline,
            title: 'Create service request',
            subtitle: 'Report a maintenance issue',
            onTap: () => context.push(AppRoutes.createRequest),
          ),
          _DashboardAction(
            key: const Key('my-requests-action'),
            icon: Icons.assignment_outlined,
            title: 'My requests',
            subtitle: 'Track open requests',
            onTap: () => context.push(AppRoutes.requests),
          ),
          _DashboardAction(
            key: const Key('history-action'),
            icon: Icons.history,
            title: 'Service history',
            subtitle: 'Review completed services',
            onTap: () => context.push(AppRoutes.history),
          ),
          const Divider(),
          Text('Apartment', style: Theme.of(context).textTheme.titleMedium),
          _DashboardAction(
            key: const Key('move-out-action'),
            icon: Icons.exit_to_app,
            title: 'Move-out request',
            subtitle: 'Start a move-out request',
            onTap: () => context.push(AppRoutes.moveOut),
          ),
          _DashboardAction(
            key: const Key('profile-action'),
            icon: Icons.person_outline,
            title: 'Resident profile',
            subtitle: 'View resident details',
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