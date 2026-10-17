import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/providers/auth_providers.dart';

class FixItApp extends ConsumerStatefulWidget {
  const FixItApp({super.key});

  @override
  ConsumerState<FixItApp> createState() => _FixItAppState();
}

class _FixItAppState extends ConsumerState<FixItApp> {
  late final _router = buildAppRouter(
    isAuthenticated: ref.read(authControllerProvider).resident != null,
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fix-it',
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}