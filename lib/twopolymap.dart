import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:latlong2/latlong.dart';

class TwoPoly extends StatefulWidget {
  const TwoPoly({Key? key}) : super(key: key);

  @override
  State<TwoPoly> createState() => _TwoPolyState();
}

class _TwoPolyState extends State<TwoPoly> {
  late PolyEditor polyEditor;
  late MapController controller;

  ///

  double angle = 0.0;

  void _onPanUpdateHandler(DragUpdateDetails details) {
    final touchPositionFromCenter = details.localPosition;
    setState(
          () {
        angle = touchPositionFromCenter.direction;
      },
    );
    print(angle);
  }

  ///
  List<Polygon> polygons = [
    Polygon(
      points: [],
      color: Colors.black,
      isFilled: true,
    ),
  ];

  final testPolygon = Polygon(
    color: Colors.black54,
    isFilled: true,
    points: [],
  );

  @override
  void initState() {
    super.initState();

    polyEditor = PolyEditor(
      addClosePathMarker: true,
      points: testPolygon.points,
      pointIcon: const Icon(Icons.crop_square, size: 10),
      intermediateIcon: const Icon(Icons.lens, size: 9, color: Colors.black87),
      callbackRefresh: () => {setState(() {})},
    );

    controller = MapController();

    polygons.add(testPolygon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: controller,
        options: MapOptions(
            onTap: (_, ll) {
              polyEditor.add(testPolygon.points, ll);
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
          DragMarkers(markers: polyEditor.edit()),
          GestureDetector(
            onPanUpdate: _onPanUpdateHandler,
            child: OverlayImageLayer(
              overlayImages: [
                // RotatedOverlayImage(
                //   imageProvider: const NetworkImage(
                //     'https://sun9-29.userapi.com/impg/lTsXSunnPlu1bAL79kEv8de8KVrhQ1mrpvqpCQ/LMHKuZh1pS0.jpg?size=1091x638&quality=96&sign=2e6badc1b7732f9c3bb4ab0a068c7216&type=album'
                //   ),
                //   topLeftCorner: LatLng(43.103203, 131.915783 + angle*0.01),
                //   bottomLeftCorner: LatLng(43.102356, 131.914743),
                //   bottomRightCorner: LatLng(43.101359 - angle*0.01, 131.918377),
                //   gaplessPlayback: true,
                // ),
                OverlayImage(
                  opacity: 0.58,
                  bounds: LatLngBounds(
                    LatLng(43.103234, 131.915774),
                    LatLng(43.101996, 131.918621),
                  ),
                  imageProvider: const NetworkImage(
                    'https://sun9-29.userapi.com/impg/lTsXSunnPlu1bAL79kEv8de8KVrhQ1mrpvqpCQ/LMHKuZh1pS0.jpg?size=1091x638&quality=96&sign=2e6badc1b7732f9c3bb4ab0a068c7216&type=album'
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.next_plan),
        onPressed: () {
          setState(() {
            print(testPolygon.points);

            List<LatLng> pointsPgn = [];
            testPolygon.points.forEach((element) {
              pointsPgn.add(LatLng(element.latitude, element.longitude));
            });
            Polygon newPolygon = Polygon(points: pointsPgn, isFilled: testPolygon.isFilled, color: Colors.primaries[Random().nextInt(Colors.primaries.length)],);
            polygons.insert(polygons.length - 1, newPolygon);

            testPolygon.points.clear();
          });
        },
      ),
    );
  }
}
