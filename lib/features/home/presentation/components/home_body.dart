import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/home/cubit/trip_cubit.dart';
import 'package:parent_app/features/home/cubit/trip_state.dart';
import 'package:parent_app/features/home/presentation/components/address_tile.dart';
import 'package:parent_app/features/home/presentation/components/parent/trip_panel.dart';
import 'package:parent_app/features/home/presentation/components/parent/trip_status.dart';
import 'package:parent_app/features/home/presentation/map_view.dart';
import 'package:parent_app/features/settings/presentation/settings_page.dart';
import 'package:parent_app/l10n/app_localizations.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
      body: BlocProvider(
        create: (context) => TripCubit(),
        child: Builder(
          builder: (context) {
            const double activeTripPanelHeight = 74;
            const double activeTripPanelBottomPadding = 16;
            final tripState = context.watch<TripCubit>().state;
            final bool hasActiveTrip = tripState is ActiveTripState;
            final activeTrip = tripState is ActiveTripState ? tripState : null;
            final double currentTripHeight = hasActiveTrip
                ? activeTripPanelHeight + activeTripPanelBottomPadding
                : 0;

            return Stack(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(color: Colors.amber),
                  child: SizedBox(
                    height: 488 - currentTripHeight,
                    width: double.infinity,
                    child: MapView(busLocation: activeTrip?.busCoords),
                  ),
                ),
                Column(
                  children: [
                    Expanded(child: Container()),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(color: Colors.black38, blurRadius: 8, spreadRadius: 3),
                        ],
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(16),
                          topEnd: Radius.circular(16),
                        ),
                      ),
                      child: SizedBox(height: 20, width: double.infinity),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(22, 12, 22, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TripStatus(),
                            SizedBox(height: 12),
                            TripPanel(height: activeTripPanelHeight),
                            AddressTile(
                              addressName: localizations.homeAddressName,
                              addressDesc: localizations.homeAddressDesc,
                              trailing: localizations.nextPickup,
                            ),
                            SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
