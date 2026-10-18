import 'package:flutter/widgets.dart';

import '../../../../l10n/app_localizations_extension.dart';
import '../providers/auth_providers.dart';

String localizedAuthError(BuildContext context, AuthState state) {
  final l10n = context.l10n;
  return switch (state.error) {
    AuthErrorCode.residentNotRecognized => l10n.residentDetailsNotRecognized,
    AuthErrorCode.otpRequestFailed =>
      l10n.otpRequestFailed(state.errorDetail ?? ''),
    AuthErrorCode.incorrectOtp => l10n.incorrectVerificationCode,
    AuthErrorCode.otpVerificationFailed =>
      l10n.otpVerificationFailed(state.errorDetail ?? ''),
    null => '',
  };
}