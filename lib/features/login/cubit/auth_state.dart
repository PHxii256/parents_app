import 'package:parent_app/core/models/user_data.dart';

sealed class AuthState {}

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
