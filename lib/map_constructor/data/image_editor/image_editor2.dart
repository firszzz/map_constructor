import 'package:flutter/widgets.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:latlong2/latlong.dart';

class ImageEditor2 {
  final List<LatLng> points;
  final Widget pointIcon;
  final Size pointIconSize;
  final Function? callbackRefresh;

  ImageEditor2({
    required this.pointIcon,
    required this.points,
    this.callbackRefresh,
    this.pointIconSize = const Size(30, 30),
  });

  int? _markerToUpdate;

  void updateMarker(details, point) {
    if (_markerToUpdate != null) {
      points[_markerToUpdate!] = LatLng(point.latitude, point.longitude);
    }
    callbackRefresh?.call();
  }

  List add(List<LatLng> pointsList, List<LatLng> points) {
    pointsList.addAll(points);
    callbackRefresh?.call();
    return pointsList;
  }

  List<DragMarker> edit() {
    List<DragMarker> dragMarkers = [];

    for (var c = 0; c < points.length; c++) {
      final indexClosure = c;
      dragMarkers.add(DragMarker(
        point: points[c],
        size: pointIconSize,
        builder: (_, __, ___) => pointIcon,
        onDragStart: (_, __) => _markerToUpdate = indexClosure,
        onDragUpdate: updateMarker,
      ));
    }

    return dragMarkers;
  }
}