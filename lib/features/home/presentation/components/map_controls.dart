import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapControls extends StatelessWidget {
  const MapControls({
    super.key,
    required MapController mapController,
    required LatLng? deviceLocation,
    this.onCenterToDeviceLocation,
    this.onRetryLocation,
    this.bottomOffset = 36,
  }) : _mapController = mapController,
       _deviceLocation = deviceLocation;

  final MapController _mapController;
  final LatLng? _deviceLocation;
  final ValueChanged<LatLng>? onCenterToDeviceLocation;
  /// When [deviceLocation] is null (e.g. GPS timeout), tapping the locate button calls this to retry.
  final VoidCallback? onRetryLocation;
  final double bottomOffset;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 12,
      bottom: bottomOffset,
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
              final target = _deviceLocation;
              if (target != null) {
                if (onCenterToDeviceLocation != null) {
                  onCenterToDeviceLocation!(target);
                  return;
                }
                _mapController.move(target, _mapController.camera.zoom);
                return;
              }
              onRetryLocation?.call();
            },
            child: const Icon(Icons.gps_fixed),
          ),
        ],
      ),
    );
  }
}
