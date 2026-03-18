import 'package:flutter/material.dart';
import 'package:parent_app/features/home/presentation/components/home_destination.dart';
import 'package:parent_app/features/home/presentation/components/parent/parent_home_body.dart';
import 'package:parent_app/features/home/presentation/home_body.dart';
import 'package:parent_app/features/locations/presentation/locations_page_body.dart';
import 'package:parent_app/features/notifications/presentation/notifications_page_body.dart';
import 'package:parent_app/features/profile/presentation/profile_page.dart';
import 'package:parent_app/l10n/app_localizations.dart';

final class ParentHomeNav extends HomeNav {
  ParentHomeNav({super.initialIndex = 0});

  @override
  List<HomeDestinationConfig> get destinations => [
    HomeDestinationConfig(
      destinationBuilder: (context, _) {
        final localizations = AppLocalizations.of(context)!;
        return NavigationDestination(icon: const Icon(Icons.home), label: localizations.homeTab);
      },
      pageBuilder: () => const HomeBody(body: ParentHomeBody()),
    ),
    HomeDestinationConfig(
      destinationBuilder: (context, _) {
        final localizations = AppLocalizations.of(context)!;
        return NavigationDestination(
          icon: const Icon(Icons.pin_drop),
          label: localizations.locationsTab,
        );
      },
      pageBuilder: () => LocationsPage(),
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
          icon: const Icon(Icons.person),
          label: localizations.profileTab,
        );
      },
      pageBuilder: () => ProfilePage(),
    ),
  ];
}
