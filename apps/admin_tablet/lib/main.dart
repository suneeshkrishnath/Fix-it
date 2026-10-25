import 'package:flutter/material.dart';

import 'admin_shell.dart';
import 'admin_theme.dart';

void main() => runApp(const FixItAdminApp());

class FixItAdminApp extends StatelessWidget {
  const FixItAdminApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Fix-it Operations',
    debugShowCheckedModeBanner: false,
    theme: AdminTheme.light,
    home: const AdminShell(),
  );
}