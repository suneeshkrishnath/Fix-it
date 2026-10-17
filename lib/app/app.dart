import 'package:flutter/material.dart';

import 'router.dart';
import '../core/theme/app_theme.dart';

class FixItApp extends StatelessWidget {
  const FixItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fix-it',
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}