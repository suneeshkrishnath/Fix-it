import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../data/repositories/hive_auth_repository.dart';
import '../../domain/models/resident.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => HiveAuthRepository(Hive.box<dynamic>('fix_it')),
);

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

enum AuthErrorCode {
  residentNotRecognized,
  otpRequestFailed,
  incorrectOtp,
  otpVerificationFailed,
}

class AuthState {
  const AuthState({
    this.resident,
    this.awaitingOtp = false,
    this.isLoading = false,
    this.error,
    this.errorDetail,
  });

  final Resident? resident;
  final bool awaitingOtp;
  final bool isLoading;
  final AuthErrorCode? error;
  final String? errorDetail;

  AuthState copyWith({
    Resident? resident,
    bool? awaitingOtp,
    bool? isLoading,
    AuthErrorCode? error,
    String? errorDetail,
    bool clearError = false,
  }) =>
      AuthState(
        resident: resident ?? this.resident,
        awaitingOtp: awaitingOtp ?? this.awaitingOtp,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : error ?? this.error,
        errorDetail: clearError ? null : errorDetail ?? this.errorDetail,
      );
}

class AuthController extends Notifier<AuthState> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  AuthState build() => AuthState(resident: _repository.readSession());

  Future<bool> requestOtp({
    required String phoneNumber,
    required String apartmentNumber,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final accepted = await _repository.requestOtp(
        phoneNumber: phoneNumber,
        apartmentNumber: apartmentNumber,
      );
      state = state.copyWith(
        isLoading: false,
        awaitingOtp: accepted,
        error: accepted ? null : AuthErrorCode.residentNotRecognized,
      );
      return accepted;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: AuthErrorCode.otpRequestFailed,
        errorDetail: error.toString(),
      );
      return false;
    }
  }

  Future<bool> verifyOtp(String code) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final resident = await _repository.verifyOtp(code);
      state = state.copyWith(
        resident: resident,
        awaitingOtp: resident == null,
        isLoading: false,
        error: resident == null ? AuthErrorCode.incorrectOtp : null,
      );
      return resident != null;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: AuthErrorCode.otpVerificationFailed,
        errorDetail: error.toString(),
      );
      return false;
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AuthState();
  }
}