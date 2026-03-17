import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/home/cubit/trip_cubit.dart';
import 'package:parent_app/features/home/cubit/trip_state.dart';
import 'package:parent_app/features/home/presentation/components/address_tile.dart';
import 'package:parent_app/features/home/presentation/components/quick_actions.dart';
import 'package:parent_app/features/home/presentation/components/trip_panel.dart';
import 'package:parent_app/features/home/presentation/components/trip_status.dart';
import 'package:parent_app/features/home/presentation/map_view.dart';
import 'package:parent_app/features/settings/presentation/settings_page.dart';
import 'package:parent_app/l10n/app_localizations.dart';

class HomeBody extends StatelessWidget {
  final Widget body;
  const HomeBody({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actionsPadding: const EdgeInsets.only(right: 8),
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            spacing: 6,
            children: [
              const Icon(Icons.bus_alert, size: 24),
              Text('Safe Route', style: const TextStyle(fontWeight: FontWeight.w700)),
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
      body: body,
    );
  }
}
