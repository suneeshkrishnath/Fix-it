import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../providers/auth_providers.dart';
import '../utils/auth_error_localization.dart';
import '../../../../app/locale_controller.dart';
import '../../../../l10n/app_localizations_extension.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _apartmentController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _apartmentController.dispose();
    super.dispose();
  }

  Future<void> _requestCode() async {
    if (!_formKey.currentState!.validate()) return;
    final accepted = await ref.read(authControllerProvider.notifier).requestOtp(
          phoneNumber: _phoneController.text,
          apartmentNumber: _apartmentController.text,
        );
    if (accepted && mounted) context.go(AppRoutes.verify);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final locale = ref.watch(localeControllerProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.residentSignIn)),
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
                    Text(l10n.selectLanguage),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      key: const Key('language-selector'),
                      showSelectedIcon: false,
                      segments: [
                        ButtonSegment(
                          value: 'en',
                          label: Text(l10n.languageEnglish),
                        ),
                        ButtonSegment(
                          value: 'ar',
                          label: Text(l10n.languageArabic),
                        ),
                      ],
                      selected: {locale.languageCode},
                      onSelectionChanged: (selection) {
                        ref
                            .read(localeControllerProvider.notifier)
                            .setLanguage(selection.first);
                      },
                    ),
                    const SizedBox(height: 28),
                    Text(
                      l10n.welcomeToFixIt,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.signInPrompt),
                    const SizedBox(height: 28),
                    TextFormField(
                      key: const Key('phone-field'),
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: l10n.phoneNumber,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.trim().isEmpty
                          ? l10n.enterPhoneNumber
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('apartment-field'),
                      controller: _apartmentController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        labelText: l10n.apartmentNumber,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.trim().isEmpty
                          ? l10n.enterApartmentNumber
                          : null,
                    ),
                    if (authState.error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        localizedAuthError(context, authState),
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: authState.isLoading ? null : _requestCode,
                      child: authState.isLoading
                          ? const CircularProgressIndicator()
                          : Text(l10n.sendVerificationCode),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.prototypeResident('+48 500000000', 'A-302'),
                      style: Theme.of(context).textTheme.bodySmall,
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