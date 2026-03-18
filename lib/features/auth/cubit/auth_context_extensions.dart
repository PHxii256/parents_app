import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/core/models/user_data.dart';
import 'package:parent_app/features/auth/cubit/auth_cubit.dart';
import 'package:parent_app/features/auth/cubit/auth_state.dart';

extension AuthContextX on BuildContext {
  AuthState get authState => read<AuthCubit>().state;

  User? get authUser => authState.userOrNull;

  String? get authRole => authUser?.role;

  String authRoleOr(String fallback) => authRole ?? fallback;
}
