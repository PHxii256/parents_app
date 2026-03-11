import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/auth/cubit/auth_state.dart';
import 'package:parent_app/features/auth/data/models/login_result.dart';
import 'package:parent_app/features/auth/data/models/otp_result.dart';
import 'package:parent_app/features/auth/data/repositories/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(UnauthenticatedState());

  void passwordLogin({required String email, required String password}) async {
    emit(AuthLoadingState());
    try {
      final res = await _authRepository.passwordLogin(email: email, password: password);
      if (res is LoginSuccess) {
        emit(
          AuthenticatedState(
            user: res.user,
            accessToken: res.accessToken,
            refreshToken: res.refreshToken,
          ),
        );
      } else if (res is LoginFailure) {
        emit(UnauthenticatedState(error: res.message));
      }
    } catch (e) {
      emit(UnauthenticatedState(error: e.toString()));
    }
  }

  void logout() async {
    if (state is AuthenticatedState) {
      final authState = state as AuthenticatedState;
      // Best-effort server-side token invalidation — always clear client state regardless.
      await _authRepository.logout(
        accessToken: authState.accessToken,
        refreshToken: authState.refreshToken,
      );
      emit(UnauthenticatedState());
    }
  }

  /// Called once on startup. Silently attempts JWT login using stored tokens.
  /// Emits [AuthLoadingState] while running, then [AuthenticatedState] on
  /// success or a silent [UnauthenticatedState] (no error) on any failure so
  /// the user is shown the login screen without a spurious error snackbar.
  void tryAutoLogin() async {
    final tokens = await _authRepository.loadStoredTokens();
    if (tokens == null) return; // no stored tokens — stay on login screen quietly
    emit(AuthLoadingState());
    try {
      final res = await _authRepository.jwtLogin(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      if (res is LoginSuccess) {
        emit(
          AuthenticatedState(
            user: res.user,
            accessToken: res.accessToken,
            refreshToken: res.refreshToken,
          ),
        );
      } else {
        // Tokens are stale/invalid — clear them and fall back to login screen.
        await _authRepository.clearStoredTokens();
        emit(UnauthenticatedState());
      }
    } catch (e) {
      await _authRepository.clearStoredTokens();
      emit(UnauthenticatedState());
    }
  }

  void jwtLogin({required String accessToken, required String refreshToken}) async {
    emit(AuthLoadingState());
    try {
      final res = await _authRepository.jwtLogin(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      if (res is LoginSuccess) {
        emit(
          AuthenticatedState(
            user: res.user,
            accessToken: res.accessToken,
            refreshToken: res.refreshToken,
          ),
        );
      } else if (res is LoginFailure) {
        emit(UnauthenticatedState(error: res.message));
      }
    } catch (e) {
      emit(UnauthenticatedState(error: e.toString()));
    }
  }

  void requestOTP({required String email}) async {
    emit(AuthLoadingState());
    try {
      final res = await _authRepository.requestOTP(email: email);
      if (res is OtpSuccess) {
        emit(OtpSentState(email: email));
      } else if (res is OtpFailure) {
        emit(UnauthenticatedState(error: res.message));
      }
    } catch (e) {
      emit(UnauthenticatedState(error: e.toString()));
    }
  }

  void resetPassword({
    required String newPassword,
    required String otp,
    required String email,
  }) async {
    emit(AuthLoadingState());
    try {
      final success = await _authRepository.resetPassword(
        newPassword: newPassword,
        otp: otp,
        email: email,
      );
      if (success) {
        emit(PasswordResetSuccessState());
      } else {
        emit(UnauthenticatedState(error: 'Failed to reset password. Please try again.'));
      }
    } catch (e) {
      emit(UnauthenticatedState(error: e.toString()));
    }
  }
}
