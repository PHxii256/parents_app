import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/home/presentation/components/home_destination.dart';
import 'package:parent_app/features/notifications/cubit/notifications_cubit.dart';
import 'package:parent_app/features/notifications/cubit/notifications_state.dart';

// Home Page (Navbar with the contents being page bodies)
class HomePage extends StatefulWidget {
  final HomeNav nav;
  const HomePage({super.key, required this.nav});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentIndex;
  late List<GlobalKey<NavigatorState>> _navigatorKeys;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.nav.initialIndex;
    _navigatorKeys = List.generate(widget.nav.destinations.length, (_) => GlobalKey());
  }

  void _onPopInvokedWithResult(bool didPop, Object? result) {
    if (didPop) {
      return;
    }

    final currentNavigator = _navigatorKeys[_currentIndex].currentState;
    final canPop = currentNavigator?.canPop() ?? false;
    if (canPop) {
      currentNavigator?.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: Scaffold(
        body: Stack(
          children: List.generate(widget.nav.destinations.length, (index) {
            return Offstage(
              offstage: _currentIndex != index,
              child: Navigator(
                key: _navigatorKeys[index],
                onGenerateRoute: (settings) => MaterialPageRoute(
                  settings: settings,
                  builder: (_) => widget.nav.destinations[index].pageBuilder(),
                ),
              ),
            );
          }),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(color: Color.fromARGB(40, 97, 117, 138), thickness: 1),
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, notificationsState) {
                final unread = notificationsState.unreadCount;
                return NavigationBar(
                  labelPadding: const EdgeInsets.only(top: 6),
                  backgroundColor: Colors.transparent,
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (value) {
                    final selectedConfig = widget.nav.destinations[value];
                    if (selectedConfig.markNotificationsAsReadOnSelect) {
                      context.read<NotificationsCubit>().markAllAsRead();
                    }
                    if (value == _currentIndex) {
                      _navigatorKeys[value].currentState?.popUntil((route) => route.isFirst);
                    } else {
                      setState(() => _currentIndex = value);
                    }
                  },
                  destinations: widget.nav.destinations
                      .map((config) => config.destinationBuilder(context, unread))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
