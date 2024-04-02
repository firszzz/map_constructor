import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GeoJsonTest extends StatefulWidget {
  const GeoJsonTest({Key? key}) : super(key: key);

  @override
  State<GeoJsonTest> createState() => _GeoJsonTestState();
}

class _GeoJsonTestState extends State<GeoJsonTest> {
  late MapController controller;

  List<Polygon> polygons = [
    Polygon(
      points: [],
      color: Colors.black,
      isFilled: true,
    ),
  ];

  @override
  void initState() {
    super.initState();

    controller = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: controller,
        options: MapOptions(
            onTap: (_, ll) {
              debugPrint(ll.toString());
            },
            zoom: 15,
            maxZoom: 27,
            center: LatLng(43.175365, 131.907421),
            onPositionChanged: (position, hasGesture) {
              debugPrint(position.zoom.toString());
            }
        ),
        children: [
          TileLayer(
            maxNativeZoom: 18,
            maxZoom: 25,
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          PolygonLayer(polygons: polygons),
        ],
      ),
    );
  }
}
