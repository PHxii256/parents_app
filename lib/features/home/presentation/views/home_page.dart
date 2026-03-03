import 'package:flutter/material.dart';
import 'package:parent_app/features/locations/views/locations_page_body.dart';
import 'package:parent_app/features/notifications/views/notifications_page_body.dart';
import 'package:parent_app/features/profile/presentation/views/profile_page_body.dart';
import 'package:parent_app/features/settings/views/settings_page.dart';
import 'package:parent_app/features/home/presentation/views/home_body.dart';

class HomePage extends StatefulWidget {
  final int? initialIndex;
  const HomePage({super.key, this.initialIndex});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentIndex;

  // Each tab gets its own navigator key, preserving its own back stack
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  void initState() {
    _currentIndex = widget.initialIndex ?? 0;
    super.initState();
  }

  // Handle Android back button: pop within the current tab before exiting
  Future<bool> _onWillPop() async {
    final canPop = _navigatorKeys[_currentIndex].currentState?.canPop() ?? false;
    if (canPop) {
      _navigatorKeys[_currentIndex].currentState?.pop();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: List.generate(4, (index) {
            // Offstage keeps all tab navigators alive without rendering them
            return Offstage(
              offstage: _currentIndex != index,
              child: _TabNavigator(navigatorKey: _navigatorKeys[index], tabIndex: index),
            );
          }),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(color: Color.fromARGB(40, 97, 117, 138), thickness: 1),
            NavigationBar(
              labelPadding: EdgeInsets.only(top: 6),
              backgroundColor: Colors.transparent,
              selectedIndex: _currentIndex,
              onDestinationSelected: (value) {
                if (value == _currentIndex) {
                  // Tap same tab — pop to root of that tab
                  _navigatorKeys[value].currentState?.popUntil((route) => route.isFirst);
                } else {
                  setState(() => _currentIndex = value);
                }
              },
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.pin_drop), label: 'Locations'),
                NavigationDestination(icon: Icon(Icons.notifications), label: 'Notifications'),
                NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Each tab's own Navigator — maintains an independent back stack
class _TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final int tabIndex;

  const _TabNavigator({required this.navigatorKey, required this.tabIndex});

  Widget _rootPage() {
    switch (tabIndex) {
      case 0:
        return const _HomeRootPage();
      case 1:
        return LocationsPage();
      case 2:
        return NotificationsPage();
      case 3:
        return ProfilePage();
      default:
        return const _HomeRootPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) =>
          MaterialPageRoute(settings: settings, builder: (_) => _rootPage()),
    );
  }
}

// Root page for the Home tab — owns the "Safe Route" AppBar
class _HomeRootPage extends StatelessWidget {
  const _HomeRootPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actionsPadding: const EdgeInsets.only(right: 8),
        title: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Row(
            spacing: 6,
            children: [
              Icon(Icons.bus_alert, size: 24),
              Text("Safe Route", style: TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingsPage()));
            },
            icon: const Icon(Icons.settings, size: 24),
            color: Colors.black,
          ),
        ],
      ),
      body: const HomeBody(),
    );
  }
}
