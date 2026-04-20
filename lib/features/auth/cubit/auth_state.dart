import 'package:parent_app/core/models/user_data.dart';

sealed class AuthState {}

class AuthLoadingState extends AuthState {}

class UnauthenticatedState extends AuthState {
  final String? error;
  UnauthenticatedState({this.error});
}

class AuthenticatedState extends AuthState {
  final User user;
  final String? refreshToken;
  final String? accessToken;
  AuthenticatedState({required this.user, this.refreshToken, this.accessToken});
}

/// Emitted after a successful OTP request — carries the email it was sent to.
class OtpSentState extends AuthState {
  final String email;
  final String role;
  final int duration;
  final String password;
  OtpSentState({
    required this.email,
    required this.role,
    required this.duration,
    required this.password,
  });
}

/// Emitted after a successful password reset — app should return to login.
class PasswordResetSuccessState extends AuthState {}

class OtpVerifiedState extends AuthState {
  final String email;
  final String role;
  final String resetToken;
  OtpVerifiedState({required this.email, required this.role, required this.resetToken});
}

extension AuthStateX on AuthState {
  User? get userOrNull {
    final current = this;
    if (current is AuthenticatedState) {
      return current.user;
    }
    return null;
  }

  String? get roleOrNull => userOrNull?.role;
}
