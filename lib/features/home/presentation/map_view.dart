import 'dart:async';
import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
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
  final LatLng? busLocation;
  final int focusRequestKey;
  const MapView({
    super.key,
    this.stackWidgets,
    this.initLocation,
    this.dragMarkers,
    this.focusTarget,
    this.busLocation,
    this.focusRequestKey = 0,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

enum _MapViewError {
  locationServicesDisabled,
  locationPermissionDenied,
  locationPermissionRequired,
}

enum _LocationFetchSource { initial, backgroundRetry, userTap }

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  static const LatLng _fallbackCenter = LatLng(30.0444, 31.2357);
  static const Duration _locationLookupTimeout = Duration(seconds: 5);
  static const int _maxBackgroundRetries = 5;
  final MapController _mapController = MapController();
  LatLng? _deviceLocation;
  LatLng? _focusedLocation;
  LatLng? _pendingFocusTarget;
  AnimationController? _focusAnimationController;
  bool _isMapReady = false;
  bool _loading = true;
  _MapViewError? _errorKey;
  Timer? _backgroundRetryTimer;
  int _backgroundRetryCount = 0;
  bool _isFetchingLocation = false;
  int _locationRequestGeneration = 0;

  @override
  void initState() {
    super.initState();
    _fetchDeviceLocation(_LocationFetchSource.initial);
  }

  @override
  void dispose() {
    _backgroundRetryTimer?.cancel();
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

  void _completeWithoutDeviceLocation(_MapViewError fallbackError) {
    if (!mounted) return;
    setState(() {
      _errorKey = widget.initLocation == null ? fallbackError : null;
    });
  }

  void _showLocationDegradedSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }

  void _showLocatingSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  bool _looksLikeTimeout(Object error) {
    if (error is TimeoutException) return true;
    final text = error.toString();
    return text.contains('Future not completed') || text.contains('TimeoutException');
  }

  void _cancelBackgroundRetry() {
    _backgroundRetryTimer?.cancel();
    _backgroundRetryTimer = null;
  }

  void _scheduleBackgroundRetry() {
    if (_backgroundRetryCount >= _maxBackgroundRetries) {
      log(
        'MapView: background location retries exhausted ($_maxBackgroundRetries)',
        name: 'MapView',
      );
      return;
    }
    _cancelBackgroundRetry();
    final delaySeconds = 8 + (_backgroundRetryCount * 6);
    _backgroundRetryTimer = Timer(Duration(seconds: delaySeconds), () {
      if (!mounted) return;
      _fetchDeviceLocation(_LocationFetchSource.backgroundRetry);
    });
    log(
      'MapView: scheduled background location retry #${_backgroundRetryCount + 1} in ${delaySeconds}s',
      name: 'MapView',
    );
  }

  Future<void> _retryLocationFromUser() {
    if (_isFetchingLocation) {
      final loc = AppLocalizations.of(context);
      if (loc != null) {
        _showLocatingSnackBar(loc.mapLocationAlreadyLocating);
      }
      return Future.value();
    }
    return _fetchDeviceLocation(_LocationFetchSource.userTap);
  }

  Future<void> _fetchDeviceLocation(_LocationFetchSource source) async {
    if (mounted && _loading) {
      setState(() => _loading = false);
    }

    if (_isFetchingLocation && source == _LocationFetchSource.backgroundRetry) {
      return;
    }

    if (source == _LocationFetchSource.userTap) {
      _cancelBackgroundRetry();
    }

    final requestGen = ++_locationRequestGeneration;

    setState(() => _isFetchingLocation = true);

    if (source == _LocationFetchSource.userTap) {
      final loc = AppLocalizations.of(context);
      if (loc != null) {
        _showLocatingSnackBar(loc.mapLocatingInProgress);
      }
    }

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _cancelBackgroundRetry();
        if (!mounted || requestGen != _locationRequestGeneration) return;
        setState(() => _isFetchingLocation = false);
        _completeWithoutDeviceLocation(_MapViewError.locationServicesDisabled);
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _cancelBackgroundRetry();
          if (!mounted || requestGen != _locationRequestGeneration) return;
          setState(() => _isFetchingLocation = false);
          _completeWithoutDeviceLocation(_MapViewError.locationPermissionDenied);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _cancelBackgroundRetry();
        if (!mounted || requestGen != _locationRequestGeneration) return;
        setState(() => _isFetchingLocation = false);
        _completeWithoutDeviceLocation(_MapViewError.locationPermissionRequired);
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: _locationLookupTimeout,
        ),
      );
      if (!mounted || requestGen != _locationRequestGeneration) return;
      _cancelBackgroundRetry();
      _backgroundRetryCount = 0;
      setState(() {
        _deviceLocation = LatLng(pos.latitude, pos.longitude);
        _errorKey = null;
        _isFetchingLocation = false;
      });
    } catch (e, stackTrace) {
      log(
        'MapView: getCurrentPosition failed (${source.name})',
        name: 'MapView',
        error: e,
        stackTrace: stackTrace,
      );
      if (!mounted || requestGen != _locationRequestGeneration) return;

      final localizations = AppLocalizations.of(context)!;
      setState(() {
        _errorKey = null;
        _isFetchingLocation = false;
      });

      final isTimeout = _looksLikeTimeout(e);

      switch (source) {
        case _LocationFetchSource.initial:
          if (isTimeout) {
            _showLocationDegradedSnackBar(localizations.mapLocationTimeout);
          } else {
            _showLocationDegradedSnackBar(localizations.mapLocationUnavailable);
          }
          _backgroundRetryCount = 0;
          _scheduleBackgroundRetry();
          break;
        case _LocationFetchSource.backgroundRetry:
          _backgroundRetryCount++;
          if (isTimeout) {
            log(
              'MapView: background retry #$_backgroundRetryCount timed out',
              name: 'MapView',
            );
          }
          if (_backgroundRetryCount < _maxBackgroundRetries) {
            _scheduleBackgroundRetry();
          }
          break;
        case _LocationFetchSource.userTap:
          if (isTimeout) {
            _showLocationDegradedSnackBar(localizations.mapLocationTimeout);
          } else {
            _showLocationDegradedSnackBar(localizations.mapLocationUnavailable);
          }
          _backgroundRetryCount = 0;
          _scheduleBackgroundRetry();
          break;
      }
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
            deviceLocation: _deviceLocation,
            busLocation: widget.busLocation,
            onMapReady: _handleMapReady,
          ),
          MapControls(
            mapController: _mapController,
            deviceLocation: _deviceLocation,
            onCenterToDeviceLocation: _animateFocusTo,
            onRetryLocation: _retryLocationFromUser,
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
  final LatLng? deviceLocation;
  final LatLng? busLocation;
  final VoidCallback? onMapReady;

  const MapCanvas({
    super.key,
    required this.mapController,
    required this.initialCenter,
    this.dragMarkers,
    this.focusedLocation,
    this.deviceLocation,
    this.busLocation,
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
        if (deviceLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: deviceLocation!,
                width: 24,
                height: 24,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ),
            ],
          ),
        if (busLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: busLocation!,
                width: 36,
                height: 36,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber.shade700,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.directions_bus, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
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
