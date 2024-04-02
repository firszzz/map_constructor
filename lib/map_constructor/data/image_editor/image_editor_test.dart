import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:latlong2/latlong.dart';

import 'image_editor2.dart';

class ImageEditorTest extends StatefulWidget {
  const ImageEditorTest({Key? key}) : super(key: key);

  @override
  State<ImageEditorTest> createState() => _ImageEditorTestState();
}

class _ImageEditorTestState extends State<ImageEditorTest> {
  late PolyEditor polyEditor;
  late MapController controller;
  ///
  late ImageEditor2 imageEditor;
  late RotatedOverlayImage rotatedOverlayImage;


  ///

  List<Polygon> polygons = [
    Polygon(
      points: [],
      color: Colors.black,
      isFilled: true,
    ),
  ];

  List<LatLng> imagePoints = [LatLng(43.103203, 131.915783), LatLng(43.102356, 131.914743), LatLng(43.101359, 131.918377)];

  final testPolygon = Polygon(
    color: Colors.black54,
    isFilled: true,
    points: [],
  );

  @override
  void initState() {
    super.initState();

    rotatedOverlayImage = RotatedOverlayImage(
      opacity: 0.34,
      /*imageProvider: const NetworkImage(
          'https://sun9-29.userapi.com/impg/lTsXSunnPlu1bAL79kEv8de8KVrhQ1mrpvqpCQ/LMHKuZh1pS0.jpg?size=1091x638&quality=96&sign=2e6badc1b7732f9c3bb4ab0a068c7216&type=album'
      ),*/
      imageProvider: const NetworkImage(
        'https://sun9-4.userapi.com/impg/r0TDimJ3iA-WDTxDBu8mfulrelCubU2AhWxC2A/AnBIV6wCffc.jpg?size=638x1091&quality=95&sign=74d21aa3483f5c6f4f452b7d25ea9fb7&type=album'
      ),
      topLeftCorner: imagePoints[0],
      bottomLeftCorner: imagePoints[1],
      bottomRightCorner: imagePoints[2],
      gaplessPlayback: true,
    );

    polyEditor = PolyEditor(
      addClosePathMarker: true,
      //points: testPolygon.points,
      points: imagePoints,
      pointIcon: const Icon(Icons.crop_square, size: 10),
      intermediateIcon: const Icon(Icons.lens, size: 9, color: Colors.black87),
      callbackRefresh: () => {setState(() {})},
    );

    controller = MapController();

    polygons.add(testPolygon);

    ///
    imageEditor = ImageEditor2(
      points: imagePoints,
      pointIcon: const Icon(Icons.crop_square, size: 15),
      callbackRefresh: () => {
        setState(() {
          rotatedOverlayImage = RotatedOverlayImage(
            opacity: 0.34,
            imageProvider: const NetworkImage(
                'https://sun9-29.userapi.com/impg/lTsXSunnPlu1bAL79kEv8de8KVrhQ1mrpvqpCQ/LMHKuZh1pS0.jpg?size=1091x638&quality=96&sign=2e6badc1b7732f9c3bb4ab0a068c7216&type=album'
            ),
            topLeftCorner: imagePoints[0],
            bottomLeftCorner: imagePoints[1],
            bottomRightCorner: imagePoints[2],
            gaplessPlayback: true,
          );

          print(rotatedOverlayImage.topLeftCorner);
          print(rotatedOverlayImage.bottomLeftCorner);
          print(rotatedOverlayImage.bottomRightCorner);
          print('---');
          print(imagePoints);
          print('');
        })
      },
    );
    ///
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
          DragMarkers(markers: imageEditor.edit()),
          GestureDetector(
            onDoubleTap: () {
              imagePoints.clear();

              imageEditor.add(imagePoints, [rotatedOverlayImage.topLeftCorner, rotatedOverlayImage.bottomRightCorner, rotatedOverlayImage.bottomLeftCorner]);
            },
            child: OverlayImageLayer(
              overlayImages: [
                rotatedOverlayImage
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