import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:parent_app/features/home/presentation/components/map_controls.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/widgets/cust_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class MapView extends StatefulWidget {
  final List<Widget>? stackWidgets;
  final LatLng? initLocation;
  final DragMarkers? dragMarkers;
  final LatLng? focusTarget;
  final int focusRequestKey;
  const MapView({
    super.key,
    this.stackWidgets,
    this.initLocation,
    this.dragMarkers,
    this.focusTarget,
    this.focusRequestKey = 0,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

enum _MapViewError {
  locationServicesDisabled,
  locationPermissionDenied,
  locationPermissionRequired,
  unknown,
}

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  static const LatLng _fallbackCenter = LatLng(30.0444, 31.2357);
  final MapController _mapController = MapController();
  LatLng? _deviceLocation;
  LatLng? _focusedLocation;
  LatLng? _pendingFocusTarget;
  AnimationController? _focusAnimationController;
  bool _isMapReady = false;
  bool _loading = true;
  _MapViewError? _errorKey;
  String? _errorDetails;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _focusAnimationController?.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _animateFocusTo(LatLng target) {
    if (!_isMapReady) {
      _pendingFocusTarget = target;
      return;
    }

    LatLng from;
    double fromZoom;
    try {
      from = _mapController.camera.center;
      fromZoom = _mapController.camera.zoom;
    } catch (_) {
      _pendingFocusTarget = target;
      return;
    }

    if (from == target) {
      _mapController.move(target, fromZoom);
      return;
    }

    final toZoom = fromZoom < 16.0 ? 16.0 : fromZoom;

    _focusAnimationController?.dispose();
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _focusAnimationController = controller;

    final animation = CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic);
    final latitudeTween = Tween<double>(begin: from.latitude, end: target.latitude);
    final longitudeTween = Tween<double>(begin: from.longitude, end: target.longitude);
    final zoomTween = Tween<double>(begin: fromZoom, end: toZoom);

    controller.addListener(() {
      _mapController.move(
        LatLng(latitudeTween.evaluate(animation), longitudeTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    controller.forward();
  }

  void _handleMapReady() {
    _isMapReady = true;

    final pending = _pendingFocusTarget;
    if (pending != null) {
      _pendingFocusTarget = null;
      _animateFocusTo(pending);
    }
  }

  @override
  void didUpdateWidget(covariant MapView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.focusTarget == null) {
      return;
    }

    final didRequestNewFocus = widget.focusRequestKey != oldWidget.focusRequestKey;
    final didFocusTargetChange = widget.focusTarget != oldWidget.focusTarget;
    if (!didRequestNewFocus && !didFocusTargetChange) {
      return;
    }

    final target = widget.focusTarget!;
    setState(() => _focusedLocation = target);
    if (_loading) {
      _pendingFocusTarget = target;
      return;
    }

    _animateFocusTo(target);
  }

  void _completeWithoutDeviceLocation(_MapViewError fallbackError, {String? details}) {
    setState(() {
      _loading = false;
      _errorKey = widget.initLocation == null ? fallbackError : null;
      _errorDetails = details;
    });
  }

  Future<void> _initLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _completeWithoutDeviceLocation(_MapViewError.locationServicesDisabled);
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _completeWithoutDeviceLocation(_MapViewError.locationPermissionDenied);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _completeWithoutDeviceLocation(_MapViewError.locationPermissionRequired);
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      setState(() {
        _deviceLocation = LatLng(pos.latitude, pos.longitude);
        _loading = false;
      });
    } catch (e) {
      _completeWithoutDeviceLocation(_MapViewError.unknown, details: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final initialCenter = widget.initLocation ?? _deviceLocation ?? _fallbackCenter;
    final errorText = switch (_errorKey) {
      _MapViewError.locationServicesDisabled => localizations.locationServicesDisabled,
      _MapViewError.locationPermissionDenied => localizations.locationPermissionDenied,
      _MapViewError.locationPermissionRequired => localizations.locationPermissionRequired,
      _MapViewError.unknown => _errorDetails,
      null => null,
    };

    return CustBuilder(
      loading: _loading,
      error: errorText,
      success: Stack(
        children: [
          MapCanvas(
            mapController: _mapController,
            initialCenter: initialCenter,
            dragMarkers: widget.dragMarkers,
            focusedLocation: _focusedLocation,
            onMapReady: _handleMapReady,
          ),
          MapControls(
            mapController: _mapController,
            deviceLocation: _deviceLocation,
            onCenterToDeviceLocation: _animateFocusTo,
          ),
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
  final LatLng? focusedLocation;
  final VoidCallback? onMapReady;

  const MapCanvas({
    super.key,
    required this.mapController,
    required this.initialCenter,
    this.dragMarkers,
    this.focusedLocation,
    this.onMapReady,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(initialCenter: initialCenter, initialZoom: 16, onMapReady: onMapReady),
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
        if (focusedLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: focusedLocation!,
                width: 40,
                height: 40,
                child: const Icon(Icons.location_pin, color: Colors.red, size: 36),
              ),
            ],
          ),
        if (dragMarkers != null) dragMarkers!,
      ],
    );
  }
}

class MapAttributionOverlay extends StatelessWidget {
  const MapAttributionOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: RichAttributionWidget(
        showFlutterMapAttribution: false,
        alignment: AttributionAlignment.bottomLeft,
        attributions: [
          TextSourceAttribution(
            localizations.openStreetMapContributors,
            onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
          ),
        ],
      ),
    );
  }
}
