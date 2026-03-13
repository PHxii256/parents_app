import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapControls extends StatelessWidget {
  const MapControls({
    super.key,
    required MapController mapController,
    required LatLng? deviceLocation,
  }) : _mapController = mapController,
       _deviceLocation = deviceLocation;

  final MapController _mapController;
  final LatLng? _deviceLocation;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 12,
      bottom: 36,
      child: Column(
        children: [
          FloatingActionButton.small(
            heroTag: 'zoom_in',
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            onPressed: () {
              _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1);
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 6),
          FloatingActionButton.small(
            heroTag: 'zoom_out',
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            onPressed: () {
              _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1);
            },
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 6),
          FloatingActionButton.small(
            heroTag: 'center',
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            onPressed: () {
              _mapController.move(_deviceLocation!, _mapController.camera.zoom);
            },
            child: const Icon(Icons.gps_fixed),
          ),
        ],
      ),
    );
  }
}
