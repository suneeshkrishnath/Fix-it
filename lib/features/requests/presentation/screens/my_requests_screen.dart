import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../l10n/app_localizations_extension.dart';
import '../../../../l10n/service_localization.dart';
import '../providers/service_request_providers.dart';

class MyRequestsScreen extends ConsumerWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(serviceRequestsProvider);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myRequests),
        actions: [
          IconButton(
            key: const Key('closed-cases-action'),
            tooltip: l10n.closedCases,
            onPressed: () => context.push(AppRoutes.closedCases),
            icon: const Icon(Icons.task_alt),
          ),
        ],
      ),
      body: requests.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l10n.couldNotLoadRequests(error.toString())),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.noRequestsYet));
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(serviceRequestsProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final request = items[index];
                return ListTile(
                  key: Key('request-${request.id}'),
                  title: Text(
                    '${request.requestNumber} · ${localizedServiceCategory(l10n, request.category)}',
                  ),
                  subtitle: Text(
                    '${localizedServiceType(l10n, request.subcategory)} · ${localizedStatus(l10n, request.status.name)}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(
                    AppRoutes.requestDetails(request.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

