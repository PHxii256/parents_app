import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:parent_app/features/home/cubit/trip_cubit.dart';
import 'package:parent_app/features/home/cubit/trip_state.dart';
import 'package:parent_app/features/home/presentation/components/address_tile.dart';
import 'package:parent_app/features/home/presentation/components/parent/parent_quick_actions.dart';
import 'package:parent_app/features/home/presentation/components/parent/trip_panel.dart';
import 'package:parent_app/features/home/presentation/components/parent/trip_status.dart';
import 'package:parent_app/features/home/presentation/components/map_controls.dart';
import 'package:parent_app/features/home/presentation/map_view.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ParentHomeBody extends StatefulWidget {
  const ParentHomeBody({super.key});

  @override
  State<ParentHomeBody> createState() => _ParentHomeBodyState();
}

class _ParentHomeBodyState extends State<ParentHomeBody> {
  late final TripCubit _tripCubit;
  MapViewControlsState? _mapControlsState;

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
          final activeTrip = state is ActiveTripState ? state : null;
          final bottomSafeArea = MediaQuery.of(context).padding.bottom;
          final mapControlsBottomOffset = switch (state) {
            ActiveTripState() => 310.0 + bottomSafeArea + 120,
            InactiveTripState() => 235.0 + bottomSafeArea + 104,
            OfflineTripState() => 255.0 + bottomSafeArea + 84,
          };
          final attributionBottomOffset = mapControlsBottomOffset - 8;

          return Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.amber),
                  child: MapView(
                    busLocation: activeTrip?.busCoords,
                    showControls: false,
                    showAttribution: false,
                    onControlsStateChanged: (controlsState) {
                      if (!mounted) return;
                      final shouldUpdate =
                          _mapControlsState == null ||
                          _mapControlsState!.deviceLocation !=
                              controlsState.deviceLocation ||
                          _mapControlsState!.mapController !=
                              controlsState.mapController;
                      if (!shouldUpdate) return;
                      setState(() {
                        _mapControlsState = controlsState;
                      });
                    },
                  ),
                ),
              ),
              Column(
                children: [
                  Expanded(child: Container()),
                  Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 8,
                              spreadRadius: 3,
                            ),
                          ],
                          borderRadius: BorderRadiusDirectional.only(
                            topStart: Radius.circular(16),
                            topEnd: Radius.circular(16),
                          ),
                        ),
                        child: SizedBox(height: 20, width: double.infinity),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
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
              ),
              if (_mapControlsState != null)
                MapControls(
                  mapController: _mapControlsState!.mapController,
                  deviceLocation: _mapControlsState!.deviceLocation,
                  onCenterToDeviceLocation:
                      _mapControlsState!.onCenterToDeviceLocation,
                  onRetryLocation: _mapControlsState!.onRetryLocation,
                  bottomOffset: mapControlsBottomOffset,
                ),
              Positioned(
                left: 8,

                bottom: attributionBottomOffset,
                child: RichAttributionWidget(
                  alignment: AttributionAlignment.bottomLeft,
                  popupBackgroundColor: Colors.white.withAlpha(220),
                  showFlutterMapAttribution: false,
                  attributions: [
                    TextSourceAttribution(
                      localizations.openStreetMapContributors,
                      onTap: () => launchUrl(
                        Uri.parse('https://openstreetmap.org/copyright'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
