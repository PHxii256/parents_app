import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/login/cubit/auth_state.dart';
import 'package:parent_app/features/login/data/models/login_result.dart';
import 'package:parent_app/features/login/data/repositories/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(UnauthenticatedState());

  void passwordLogin({required String email, required String password}) async {
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
      final res = await _authRepository.logout(
        accessToken: authState.accessToken,
        refreshToken: authState.refreshToken,
      );
      if (res == true) emit(UnauthenticatedState());
    }
  }

  // Rest to be continued...
}
