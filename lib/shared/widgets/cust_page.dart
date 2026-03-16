import 'package:flutter/material.dart';
import 'package:parent_app/features/home/presentation/home_page.dart';
import 'package:parent_app/features/locations/presentation/locations_page_body.dart';
import 'package:parent_app/features/notifications/presentation/notifications_page_body.dart';
import 'package:parent_app/features/profile/presentation/profile_page_body.dart' hide ProfilePage;
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/features/settings/presentation/settings_page.dart';
import 'package:parent_app/features/home/presentation/home_body.dart';

import '../../features/profile/presentation/profile_page.dart';

class CustPage extends StatefulWidget {
  final Widget page;
  const CustPage({super.key, required this.page});

  @override
  State<CustPage> createState() => _CustPageState();
}

class _CustPageState extends State<CustPage> {
  bool showAppBar = true;
  int currentWidgetIndex = 0;
  Widget currentBody = HomeBody();
  final List<Widget> destinations = [
    HomeBody(),
    LocationsPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    currentBody = widget.page;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
              NavigationDestination(icon: const Icon(Icons.home), label: localizations.homeTab),
              NavigationDestination(
                icon: const Icon(Icons.pin_drop),
                label: localizations.locationsTab,
              ),
              NavigationDestination(
                icon: const Icon(Icons.notifications),
                label: localizations.notificationsTab,
              ),
              NavigationDestination(
                icon: const Icon(Icons.person),
                label: localizations.profileTab,
              ),
            ],
            selectedIndex: currentWidgetIndex,
            onDestinationSelected: (value) {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(
                context,
              ).pushReplacement(MaterialPageRoute(builder: (_) => HomePage(initialIndex: value)));
            },
          ),
        ],
      ),
      body: currentBody,
      appBar: currentWidgetIndex == 0 && currentBody.runtimeType == HomeBody().runtimeType
          ? AppBar(
              backgroundColor: Colors.transparent,
              actionsPadding: EdgeInsets.only(right: 8),
              title: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  spacing: 6,
                  children: [
                    const Icon(Icons.bus_alert, size: 24),
                    Text("Safe Route", style: const TextStyle(fontWeight: FontWeight.w700)),
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
