import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/generated/app_localizations.dart';
import 'router.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/technician/presentation/providers/technician_providers.dart';
import 'locale_controller.dart';

class FixItApp extends ConsumerStatefulWidget {
  const FixItApp({super.key});

  @override
  ConsumerState<FixItApp> createState() => _FixItAppState();
}

class _FixItAppState extends ConsumerState<FixItApp> {
  late final _router = buildAppRouter(
    isAuthenticated: ref.read(authControllerProvider).resident != null,
    isTechnicianAuthenticated: ref.read(technicianSessionProvider) != null,
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeControllerProvider);
    return MaterialApp.router(
      title: 'Fix-it',
      theme: AppTheme.light,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
