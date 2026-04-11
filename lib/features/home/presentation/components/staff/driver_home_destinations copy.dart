import 'package:flutter/material.dart';
import 'package:parent_app/features/home/presentation/components/home_destination.dart';
import 'package:parent_app/features/home/presentation/components/staff/staff_home_body.dart';
import 'package:parent_app/features/home/presentation/home_body.dart';
import 'package:parent_app/l10n/app_localizations.dart';

final class DriverHomeNav extends HomeNav {
  DriverHomeNav({super.initialIndex = 0});

  @override
  List<HomeDestinationConfig> get destinations => [
    HomeDestinationConfig(
      destinationBuilder: (context, _) {
        final localizations = AppLocalizations.of(context)!;
        return NavigationDestination(icon: const Icon(Icons.home), label: localizations.homeTab);
      },
      pageBuilder: () => const HomeBody(body: StaffHomeBody()),
    ),
  ];
}
