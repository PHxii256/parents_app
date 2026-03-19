import 'package:flutter/material.dart';
import 'package:parent_app/features/home/presentation/components/home_destination.dart';
import 'package:parent_app/features/home/presentation/components/staff/staff_home_body.dart';
import 'package:parent_app/features/students/presentation/students_page.dart';
import 'package:parent_app/features/home/presentation/home_body.dart';
import 'package:parent_app/features/notifications/presentation/notifications_page_body.dart';
import 'package:parent_app/l10n/app_localizations.dart';

final class StaffHomeNav extends HomeNav {
  StaffHomeNav({super.initialIndex = 0});

  @override
  List<HomeDestinationConfig> get destinations => [
    HomeDestinationConfig(
      destinationBuilder: (context, _) {
        final localizations = AppLocalizations.of(context)!;
        return NavigationDestination(icon: const Icon(Icons.home), label: localizations.homeTab);
      },
      pageBuilder: () => const HomeBody(body: StaffHomeBody()),
    ),

    HomeDestinationConfig(
      destinationBuilder: (context, _) {
        final localizations = AppLocalizations.of(context)!;
        return NavigationDestination(icon: const Icon(Icons.person), label: "Students");
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
  ];
}
