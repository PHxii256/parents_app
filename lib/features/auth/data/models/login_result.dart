import 'package:parent_app/core/models/user_data.dart';

sealed class LoginResult {}

class LoginSuccess extends LoginResult {
  final User user;
  final String? refreshToken;
  final String? accessToken;
  LoginSuccess({required this.user, this.refreshToken, this.accessToken});
}

class LoginFailure extends LoginResult {
  final String message;
  LoginFailure(this.message);
}

class LoginOtpRequired extends LoginResult {
  final String email;
  final String role;
  final int remainingSeconds;
  final String password;

  LoginOtpRequired({
    required this.email,
    required this.role,
    required this.remainingSeconds,
    required this.password,
  });
}
