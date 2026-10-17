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

class AuthState {
  const AuthState({
    this.resident,
    this.awaitingOtp = false,
    this.isLoading = false,
    this.error,
  });

  final Resident? resident;
  final bool awaitingOtp;
  final bool isLoading;
  final String? error;

  AuthState copyWith({
    Resident? resident,
    bool? awaitingOtp,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) =>
      AuthState(
        resident: resident ?? this.resident,
        awaitingOtp: awaitingOtp ?? this.awaitingOtp,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : error ?? this.error,
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
        error: accepted ? null : 'Resident details were not recognized.',
      );
      return accepted;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: 'Could not request a verification code: $error',
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
        error: resident == null ? 'The verification code is incorrect.' : null,
      );
      return resident != null;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: 'Could not verify the code: $error',
      );
      return false;
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AuthState();
  }
}