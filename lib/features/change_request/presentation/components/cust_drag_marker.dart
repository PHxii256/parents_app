import 'package:flutter/material.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:latlong2/latlong.dart';

DragMarker custMarker({
  required LatLng initPoint,
  Function(DragStartDetails, LatLng)? onDragStart,
  Function(DragEndDetails, LatLng)? onDragEnd,
  Function(LatLng)? onTap,
  Function(LatLng)? onLongPress,
}) {
  return DragMarker(
    key: GlobalKey<DragMarkerWidgetState>(),
    point: initPoint,
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
    onDragStart: onDragStart ?? (details, point) => debugPrint("Start point $point"),
    onDragEnd: onDragEnd ?? (details, point) => debugPrint("End point $point"),
    onTap: onTap ?? (point) => debugPrint("on tap"),
    onLongPress: onLongPress ?? (point) => debugPrint("on long press"),
    scrollMapNearEdge: true,
    scrollNearEdgeRatio: 2.0,
    scrollNearEdgeSpeed: 2.0,
  );
}
