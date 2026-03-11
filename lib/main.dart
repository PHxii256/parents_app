import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/auth/cubit/auth_cubit.dart';
import 'package:parent_app/features/auth/data/repositories/auth_repository.dart';
import 'package:parent_app/features/auth/presentation/auth_gate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => AuthRepository(),
      child: BlocProvider(
        create: (ctx) {
          final cubit = AuthCubit(authRepository: ctx.read<AuthRepository>());
          cubit.tryAutoLogin();
          return cubit;
        },
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
            radioTheme: RadioThemeData(fillColor: WidgetStateProperty.all(Colors.black87)),
            fontFamily: 'Lexend',
          ),
          home: const AuthGate(),
        ),
      ),
    );
  }
}
