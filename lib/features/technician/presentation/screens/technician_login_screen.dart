import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../l10n/app_localizations_extension.dart';
import '../providers/technician_providers.dart';

class TechnicianLoginScreen extends ConsumerStatefulWidget {
  const TechnicianLoginScreen({super.key});

  @override
  ConsumerState<TechnicianLoginScreen> createState() =>
      _TechnicianLoginScreenState();
}

class _TechnicianLoginScreenState extends ConsumerState<TechnicianLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _technicianIdController = TextEditingController();
  String? _error;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _technicianIdController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    final signedIn = await ref
        .read(technicianSessionProvider.notifier)
        .signIn(_technicianIdController.text);
    if (signedIn) {
      await ref.read(authControllerProvider.notifier).signOut();
    }
    if (!mounted) return;
    final l10n = context.l10n;
    setState(() {
      _isSubmitting = false;
      _error = signedIn ? null : l10n.technicianIdNotRecognized;
    });
    if (signedIn) context.go('/technician/jobs');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.technicianSignIn)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.technicianWorkspace,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.technicianPrototypeAuthNotice),
                    const SizedBox(height: 24),
                    TextFormField(
                      key: const Key('technician-id-field'),
                      controller: _technicianIdController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        labelText: l10n.technicianLoginId,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? l10n.enterTechnicianId
                          : null,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      key: const Key('technician-sign-in'),
                      onPressed: _isSubmitting ? null : _signIn,
                      child: _isSubmitting
                          ? const CircularProgressIndicator()
                          : Text(l10n.signIn),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.demoTechnicianId,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(l10n.residentSignIn),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
