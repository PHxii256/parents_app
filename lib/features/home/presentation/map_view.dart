import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:parent_app/features/home/presentation/components/map_controls.dart';
import 'package:parent_app/shared/widgets/cust_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class MapView extends StatefulWidget {
  final List<Widget>? stackWidgets;
  final LatLng? initLocation;
  final DragMarkers? dragMarkers;
  const MapView({super.key, this.stackWidgets, this.initLocation, this.dragMarkers});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapController _mapController = MapController();
  LatLng? _deviceLocation;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _loading = false;
          _error = 'Location services are disabled.';
        });
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _loading = false;
            _error = 'Location permission denied.';
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _loading = false;
          _error = 'Please turn on the location permission to view the map.';
        });
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      setState(() {
        _deviceLocation = LatLng(pos.latitude, pos.longitude);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustBuilder(
      loading: _loading,
      error: _error,
      success: Stack(
        children: [
          MapCanvas(
            mapController: _mapController,
            initialCenter: widget.initLocation ?? _deviceLocation!,
            dragMarkers: widget.dragMarkers,
          ),
          MapControls(mapController: _mapController, deviceLocation: _deviceLocation),
          ...(widget.stackWidgets ?? [SizedBox.shrink()]),
        ],
      ),
    );
  }
}

class MapCanvas extends StatelessWidget {
  final MapController mapController;
  final LatLng initialCenter;
  final DragMarkers? dragMarkers;

  const MapCanvas({
    super.key,
    required this.mapController,
    required this.initialCenter,
    this.dragMarkers,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(initialCenter: initialCenter, initialZoom: 16),
      children: [
        TileLayer(
          errorTileCallback: (tile, error, stackTrace) {
            debugPrint('Tile error: $error');
            if (stackTrace != null) {
              debugPrint(stackTrace.toString());
            }
          },
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.safe_route.app',
        ),
        const MapAttributionOverlay(),
        CurrentLocationLayer(),
        if (dragMarkers != null) dragMarkers!,
      ],
    );
  }
}

class MapAttributionOverlay extends StatelessWidget {
  const MapAttributionOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: RichAttributionWidget(
        showFlutterMapAttribution: false,
        alignment: AttributionAlignment.bottomLeft,
        attributions: [
          TextSourceAttribution(
            'OpenStreetMap contributors',
            onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
          ),
        ],
      ),
    );
  }
}
