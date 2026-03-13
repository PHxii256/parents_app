import 'package:flutter/material.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:latlong2/latlong.dart';
import 'package:parent_app/features/change_request/presentation/components/confirm_location_button.dart';
import 'package:parent_app/features/change_request/presentation/components/cust_drag_marker.dart';
import 'package:parent_app/features/home/presentation/map_view.dart';
import 'package:parent_app/features/locations/presentation/gmaps_search.dart';

class AddLocationPage extends StatefulWidget {
  const AddLocationPage({super.key});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  LatLng? _locationCoords;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          centerTitle: true,
          title: Text("Add Location", style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        GmapsSearch(cb: (coords) => setState(() => _locationCoords = coords)),
        SizedBox(height: 8),
        _locationCoords != null
            ? Expanded(
                child: MapView(
                  stackWidgets: [ConfirmLocationButton()],
                  initLocation: _locationCoords!,
                  dragMarkers: DragMarkers(markers: [custMarker(initPoint: _locationCoords!)]),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
