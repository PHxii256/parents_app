import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/auth/cubit/auth_cubit.dart';
import 'package:parent_app/features/settings/cubit/settings_cubit.dart';
import 'package:parent_app/features/settings/cubit/settings_state.dart';
import 'package:parent_app/features/settings/presentation/change_password_page.dart';
import 'package:parent_app/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  void logout(BuildContext ctx) {
    ctx.read<AuthCubit>().logout();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localizations.settingsTitle,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<SettingsCubit>().loadSavedLanguage(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          children: [
            ListTile(
              title: Text(localizations.changePasswordTitle),
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
              ),
              trailing: const Icon(Icons.lock_outline),
            ),
            ListTile(
              title: Text(localizations.logout),
              onTap: () => logout(context),
              trailing: const Icon(Icons.logout_outlined),
            ),
            const LanguageSwitch(),
          ],
        ),
      ),
    );
  }
}

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return ListTile(
          title: Text(localizations.switchLanguage),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              Text(localizations.languagePair, style: const TextStyle(fontSize: 14)),
              Switch(
                padding: EdgeInsets.all(0),
                value: state.isArabicSwitchOn,
                onChanged: (current) {
                  context.read<SettingsCubit>().toggleLanguage(current);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
