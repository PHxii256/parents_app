import 'package:flutter/material.dart';
import 'package:parent_app/features/locations/views/locations_page_body.dart';
import 'package:parent_app/features/notifications/views/notifications_page_body.dart';
import 'package:parent_app/features/profile/views/profile_page_body.dart';
import 'package:parent_app/features/settings/views/settings_page.dart';
import 'package:parent_app/features/home/views/home_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showAppBar = true;
  int currentWidgetIndex = 0;
  final List<Widget> destinations = [
    HomeBody(),
    LocationsPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: Color.fromARGB(40, 97, 117, 138), thickness: 1),
          NavigationBar(
            labelPadding: EdgeInsets.only(top: 6),
            backgroundColor: Colors.transparent,
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.pin_drop), label: 'Locations'),
              NavigationDestination(icon: Icon(Icons.notifications), label: 'Notifications'),
              NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
            ],
            selectedIndex: currentWidgetIndex,
            onDestinationSelected: (value) {
              setState(() => currentWidgetIndex = value);
            },
          ),
        ],
      ),
      body: destinations[currentWidgetIndex],
      appBar: currentWidgetIndex == 0
          ? AppBar(
              backgroundColor: Colors.transparent,
              actionsPadding: EdgeInsets.only(right: 8),
              title: Padding(
                padding: const EdgeInsets.only(left: 8),
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
                  icon: Icon(Icons.settings, size: 24),
                  color: Colors.black,
                ),
              ],
            )
          : null,
    );
  }
}
