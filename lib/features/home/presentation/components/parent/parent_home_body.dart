import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/home/cubit/trip_cubit.dart';
import 'package:parent_app/features/home/cubit/trip_state.dart';
import 'package:parent_app/features/home/presentation/components/address_tile.dart';
import 'package:parent_app/features/home/presentation/components/parent/parent_quick_actions.dart';
import 'package:parent_app/features/home/presentation/components/parent/trip_panel.dart';
import 'package:parent_app/features/home/presentation/components/parent/trip_status.dart';
import 'package:parent_app/features/home/presentation/map_view.dart';
import 'package:parent_app/l10n/app_localizations.dart';

class ParentHomeBody extends StatefulWidget {
  const ParentHomeBody({super.key});

  @override
  State<ParentHomeBody> createState() => _ParentHomeBodyState();
}

class _ParentHomeBodyState extends State<ParentHomeBody> {
  late final TripCubit _tripCubit;

  @override
  void initState() {
    super.initState();
    _tripCubit = TripCubit();
  }

  @override
  void dispose() {
    _tripCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: _tripCubit,
      child: BlocBuilder<TripCubit, TripState>(
        builder: (context, state) {
          const double activeTripPanelHeight = 74;
          const double activeTripPanelBottomPadding = 6;
          final bool hasActiveTrip = state is ActiveTripState;
          final activeTrip = state is ActiveTripState ? state : null;
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
                      boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 8, spreadRadius: 3)],
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
                      padding: EdgeInsets.fromLTRB(22, 12, 22, 8),
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
                          ParentQuickActions(),
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
    );
  }
}
