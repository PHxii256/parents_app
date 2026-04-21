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
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (prev, next) {
        if (next is AuthenticatedState && prev is! AuthenticatedState) {
          return true;
        }
        return next is UnauthenticatedState && next.error != null;
      },
      listener: (context, state) {
        if (state is AuthenticatedState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
          });
          return;
        }
        if (state is UnauthenticatedState && state.error != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            final messenger = ScaffoldMessenger.maybeOf(context);
            messenger?.clearSnackBars();
            messenger?.showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.error!),
              ),
            );
          });
        }
      },
      builder: (context, state) {
        if (state is AuthenticatedState &&
            !_allowedRoles.contains(state.user.role.toLowerCase().trim())) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            context.read<AuthCubit>().logout();
          });
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        // Keep [LoginPage] mounted during auth loading so email/password fields are not cleared.
        return switch (state) {
          AuthenticatedState() => HomePage(nav: HomeNav.forRole(state.user.role)),
          AuthLoadingState() ||
          UnauthenticatedState() ||
          OtpSentState() ||
          OtpVerifiedState() ||
          PasswordResetSuccessState() => const LoginPage(),
        };
      },
    );
  }
}
