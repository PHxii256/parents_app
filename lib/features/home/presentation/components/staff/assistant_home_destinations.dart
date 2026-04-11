import 'package:flutter/material.dart';
import 'package:parent_app/features/home/presentation/components/home_destination.dart';
import 'package:parent_app/features/students/presentation/students_page.dart';
import 'package:parent_app/features/notifications/presentation/notifications_page_body.dart';
import 'package:parent_app/features/settings/presentation/settings_page.dart';
import 'package:parent_app/l10n/app_localizations.dart';

final class AssistantHomeNav extends HomeNav {
  AssistantHomeNav({super.initialIndex = 0});

  @override
  List<HomeDestinationConfig> get destinations => [
    HomeDestinationConfig(
      destinationBuilder: (context, _) {
        final localizations = AppLocalizations.of(context)!;
        return NavigationDestination(icon: const Icon(Icons.person), label: localizations.students);
      },
      pageBuilder: () => StudentsPage(),
    ),

    HomeDestinationConfig(
      destinationBuilder: (context, unread) {
        final localizations = AppLocalizations.of(context)!;
        return NavigationDestination(
          icon: notificationsIcon(unread),
          label: localizations.notificationsTab,
        );
      },
      pageBuilder: () => NotificationsPage(),
      markNotificationsAsReadOnSelect: true,
    ),

    HomeDestinationConfig(
      destinationBuilder: (context, _) {
        final localizations = AppLocalizations.of(context)!;
        return NavigationDestination(
          icon: const Icon(Icons.settings),
          label: localizations.settingsTitle,
        );
      },
      pageBuilder: () => SettingsPage(),
    ),
  ];
}
