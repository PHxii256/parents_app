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
  late Set<int> _initializedTabs;

  int _clampIndex(int desiredIndex, int length) {
    if (length <= 0) {
      return 0;
    }
    if (desiredIndex < 0) {
      return 0;
    }
    if (desiredIndex >= length) {
      return length - 1;
    }
    return desiredIndex;
  }

  @override
  void initState() {
    super.initState();
    final destinationsLength = widget.nav.destinations.length;
    _currentIndex = _clampIndex(widget.nav.initialIndex, destinationsLength);
    _navigatorKeys = List.generate(destinationsLength, (_) => GlobalKey());
    _initializedTabs = {_currentIndex};

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<NotificationsCubit>().init();
    });
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.nav != widget.nav) {
      final destinationsLength = widget.nav.destinations.length;
      _currentIndex = _clampIndex(widget.nav.initialIndex, destinationsLength);
      _navigatorKeys = List.generate(destinationsLength, (_) => GlobalKey());
      _initializedTabs = {_currentIndex};
    }
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
    final destinations = widget.nav.destinations;
    final hasBottomNav = destinations.length >= 2;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: Scaffold(
        body: Stack(
          children: List.generate(destinations.length, (index) {
            return Offstage(
              offstage: _currentIndex != index,
              child: _initializedTabs.contains(index)
                  ? TickerMode(
                      enabled: _currentIndex == index,
                      child: Navigator(
                        key: _navigatorKeys[index],
                        onGenerateRoute: (settings) => MaterialPageRoute(
                          settings: settings,
                          builder: (_) => destinations[index].pageBuilder(),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            );
          }),
        ),
        bottomNavigationBar: hasBottomNav
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(
                    color: Color.fromARGB(40, 97, 117, 138),
                    thickness: 1,
                  ),
                  BlocBuilder<NotificationsCubit, NotificationsState>(
                    builder: (context, notificationsState) {
                      final unread = notificationsState.unreadCount;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: NavigationBar(
                          labelPadding: const EdgeInsets.only(top: 6),
                          backgroundColor: Colors.transparent,
                          selectedIndex: _currentIndex,
                          onDestinationSelected: (value) {
                            final selectedConfig = destinations[value];
                            if (selectedConfig
                                .markNotificationsAsReadOnSelect) {
                              context
                                  .read<NotificationsCubit>()
                                  .markAllAsRead();
                            }
                            if (value == _currentIndex) {
                              _navigatorKeys[value].currentState?.popUntil(
                                (route) => route.isFirst,
                              );
                            } else {
                              setState(() {
                                _currentIndex = value;
                                _initializedTabs.add(value);
                              });
                            }
                          },
                          destinations: destinations
                              .map(
                                (config) =>
                                    config.destinationBuilder(context, unread),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
