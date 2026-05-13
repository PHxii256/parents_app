import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:parent_app/features/home/cubit/trip_cubit.dart';
import 'package:parent_app/features/home/cubit/trip_state.dart';
import 'package:parent_app/features/home/presentation/components/address_tile.dart';
import 'package:parent_app/features/home/presentation/components/parent/parent_quick_actions.dart';
import 'package:parent_app/features/home/presentation/components/parent/trip_panel.dart';
import 'package:parent_app/features/home/presentation/components/parent/trip_status.dart';
import 'package:parent_app/core/config/api_config.dart';
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
  LatLng? _mapFocusTarget;
  int _mapFocusRequestKey = 0;
  bool _showBusActionIcon = false;
  bool _followBusLocation = false;

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

  void _focusOnSelfLocation() {
    final controls = _mapControlsState;
    if (controls == null) return;
    final location = controls.deviceLocation;
    if (location != null) {
      controls.onCenterToDeviceLocation(location);
      return;
    }
    controls.onRetryLocation();
  }

  void _focusOnBusLocation(ActiveTripState activeTrip) {
    final busLocation = ApiConfig.useRealApi ? activeTrip.busCoords : null;
    if (busLocation == null) {
      return;
    }
    setState(() {
      _mapFocusTarget = busLocation;
      _mapFocusRequestKey++;
    });
  }

  void _handleCenterControlTap(ActiveTripState? activeTrip) {
    if (activeTrip == null) {
      _focusOnSelfLocation();
      return;
    }
    if (_showBusActionIcon) {
      _focusOnBusLocation(activeTrip);
      setState(() {
        _showBusActionIcon = false;
        _followBusLocation = true;
      });
      return;
    }
    _focusOnSelfLocation();
    setState(() {
      _showBusActionIcon = true;
      _followBusLocation = false;
    });
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
          if (activeTrip == null && (_showBusActionIcon || _followBusLocation)) {
            _showBusActionIcon = false;
            _followBusLocation = false;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.amber),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      MapView(
                        focusTarget: _mapFocusTarget,
                        focusRequestKey: _mapFocusRequestKey,
                        busLocation:
                            ApiConfig.useRealApi ? activeTrip?.busCoords : null,
                        showBusMarkerAtMapLoadCenter:
                            activeTrip != null && !ApiConfig.useRealApi,
                        followBusLocation:
                            activeTrip != null && ApiConfig.useRealApi && _followBusLocation,
                        showControls: true,
                        showAttribution: false,
                        controlsBottomOffset: 36,
                        centerControlIcon: activeTrip != null && _showBusActionIcon
                            ? Icons.directions_bus
                            : Icons.gps_fixed,
                        onCenterControlPressed: () => _handleCenterControlTap(activeTrip),
                        onControlsStateChanged: (controlsState) {
                          _mapControlsState = controlsState;
                        },
                      ),
                      Positioned(
                        left: 8,
                        bottom: 8,
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
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
              ),
            ],
          );
        },
      ),
    );
  }
}
