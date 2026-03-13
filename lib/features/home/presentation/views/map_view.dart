import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

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
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!, textAlign: TextAlign.center));
    }
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(initialCenter: _deviceLocation!, initialZoom: 16),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.safe_route.app',
            ),
            Padding(
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
            ),
            CurrentLocationLayer(),
            DragMarkers(
              markers: [
                // marker with drag feedback, map scrolls when near edge
                DragMarker(
                  key: GlobalKey<DragMarkerWidgetState>(),
                  point: const LatLng(30.012185, 30.986861),
                  size: const Size.square(75),
                  offset: const Offset(0, -20),
                  dragOffset: const Offset(0, -35),
                  builder: (_, __, isDragging) {
                    return const Stack(
                      alignment: AlignmentGeometry.center,
                      children: [
                        // The outline icon provides the 'stroke'
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.black, // Stroke color
                          size: 50.0,
                        ),
                        // The filled icon provides the 'body'
                        Align(
                          alignment: AlignmentGeometry.xy(0.01, -0.05),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.yellowAccent, // Icon body color
                            size: 38.0,
                          ),
                        ),
                      ],
                    );
                  },
                  onDragStart: (details, point) => debugPrint("Start point $point"),
                  onDragEnd: (details, point) => debugPrint("End point $point"),
                  onTap: (point) => debugPrint("on tap"),
                  onLongPress: (point) => debugPrint("on long press"),
                  scrollMapNearEdge: true,
                  scrollNearEdgeRatio: 2.0,
                  scrollNearEdgeSpeed: 2.0,
                ),
              ],
            ),
          ],
        ),
        Positioned(
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
        ),
      ],
    );
  }
}
