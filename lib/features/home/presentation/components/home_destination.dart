import 'package:flutter/material.dart';
import 'package:parent_app/features/home/presentation/components/parent/parent_home_destinations.dart';
import 'package:parent_app/features/home/presentation/components/staff/staff_home_destinations.dart';

final class HomeDestinationConfig {
  final NavigationDestination Function(BuildContext context, int unreadCount) destinationBuilder;
  final Widget Function() pageBuilder;
  final bool markNotificationsAsReadOnSelect;

  const HomeDestinationConfig({
    required this.destinationBuilder,
    required this.pageBuilder,
    this.markNotificationsAsReadOnSelect = false,
  });
}

abstract class HomeNav {
  const HomeNav({required this.initialIndex});

  final int initialIndex;
  List<HomeDestinationConfig> get destinations;

  static HomeNav forRole(String role) {
    switch (role.toLowerCase()) {
      case 'bus_staff':
      case 'staff':
      case 'driver':
      case 'assistant':
        return StaffHomeNav();
      case 'parent':
      case 'guardian':
      default:
        return ParentHomeNav();
    }
  }

  Widget notificationsIcon(int unreadCount) {
    if (unreadCount > 0) {
      return Badge(
        label: Text(unreadCount > 99 ? '99+' : '$unreadCount'),
        child: const Icon(Icons.notifications),
      );
    }
    return const Icon(Icons.notifications);
  }
}
