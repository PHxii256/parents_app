import 'package:flutter/material.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:latlong2/latlong.dart';
import 'package:parent_app/features/change_request/presentation/components/confirm_location_button.dart';
import 'package:parent_app/features/change_request/presentation/components/cust_drag_marker.dart';
import 'package:parent_app/features/home/presentation/map_view.dart';
import 'package:parent_app/features/locations/presentation/gmaps_search.dart';
import 'package:parent_app/l10n/app_localizations.dart';

class AddLocationPage extends StatefulWidget {
  const AddLocationPage({super.key});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  LatLng? _locationCoords;
  /// Tracks the draggable pin (search sets it; dragging updates it).
  LatLng? _markerLatLng;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        AppBar(
          centerTitle: true,
          title: Text(
            localizations.addLocationTitle,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        GmapsSearch(
          cb: (coords) => setState(() {
            _locationCoords = coords;
            _markerLatLng = coords;
          }),
        ),
        const SizedBox(height: 8),
        _locationCoords != null && _markerLatLng != null
            ? Expanded(
                child: MapView(
                  stackWidgets: [
                    ConfirmLocationButton(markerLatLng: () => _markerLatLng!),
                  ],
                  initLocation: _locationCoords!,
                  dragMarkers: DragMarkers(
                    markers: [
                      custMarker(
                        initPoint: _locationCoords!,
                        onDragEnd: (_, point) => setState(() => _markerLatLng = point),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
