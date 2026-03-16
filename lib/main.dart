import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parent_app/features/auth/cubit/auth_cubit.dart';
import 'package:parent_app/features/auth/data/repositories/auth_repository.dart';
import 'package:parent_app/features/auth/presentation/auth_gate.dart';
import 'package:parent_app/features/notifications/cubit/notifications_cubit.dart';
import 'package:parent_app/features/notifications/data/repositories/notifications_repository.dart';
import 'package:parent_app/features/notifications/data/services/fcm_service.dart';
import 'package:parent_app/features/settings/cubit/settings_cubit.dart';
import 'package:parent_app/features/settings/cubit/settings_state.dart';
import 'package:parent_app/firebase_options.dart';
import 'package:parent_app/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => NotificationsRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) {
              final cubit = AuthCubit(authRepository: ctx.read<AuthRepository>());
              cubit.tryAutoLogin();
              return cubit;
            },
          ),
          BlocProvider(
            create: (_) {
              final cubit = SettingsCubit();
              cubit.loadSavedLanguage();
              return cubit;
            },
          ),
          BlocProvider(
            create: (ctx) {
              final cubit = NotificationsCubit(repository: ctx.read<NotificationsRepository>());
              cubit.init();
              return cubit;
            },
          ),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Parent App',
              locale: state.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
                radioTheme: RadioThemeData(fillColor: WidgetStateProperty.all(Colors.black87)),
                fontFamily: 'Lexend',
              ),
              home: const AuthGate(),
            );
          },
        ),
      ),
    );
  }
}
