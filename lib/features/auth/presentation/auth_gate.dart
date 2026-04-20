import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/auth/cubit/auth_cubit.dart';
import 'package:parent_app/features/auth/cubit/auth_state.dart';
import 'package:parent_app/features/auth/presentation/login_page.dart';
import 'package:parent_app/features/home/presentation/components/home_destination.dart';
import 'package:parent_app/features/home/presentation/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  static const Set<String> _allowedRoles = {'parent', 'guardian', 'driver', 'assistant'};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthenticatedState &&
            !_allowedRoles.contains(state.user.role.toLowerCase().trim())) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            context.read<AuthCubit>().logout();
          });
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return switch (state) {
          AuthenticatedState() => HomePage(nav: HomeNav.forRole(state.user.role)),
          AuthLoadingState() => const Scaffold(body: Center(child: CircularProgressIndicator())),
          UnauthenticatedState() ||
          OtpSentState() ||
          OtpVerifiedState() ||
          PasswordResetSuccessState() => LoginPage(),
        };
      },
    );
  }
}
