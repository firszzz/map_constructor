// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
// import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
// import 'package:geojson_test/data/custom_overlay_image.dart';
// import 'package:geojson_test/data/image_points.dart';
// import 'package:latlong2/latlong.dart';
//
// import 'map_constructor/data/image_editor/image_editor2.dart';
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   late PolyEditor polyEditor;
//   late MapController controller;
//   ///
//   late ImageEditor2 imageEditor;
//   late CustomOverlayImage rotatedOverlayImage;
//
//   late ImagePoints imagePoints;
//
//   List<LatLng> imagePointsData = [];
//
//   double opacity = 0.25;
//
//   bool imageSelected = false;
//
//   refreshImage() {
//     setState(() {
//       rotatedOverlayImage = CustomOverlayImage(
//         opacity: opacity,
//         imageProvider: const NetworkImage(
//             'https://sun9-29.userapi.com/impg/lTsXSunnPlu1bAL79kEv8de8KVrhQ1mrpvqpCQ/LMHKuZh1pS0.jpg?size=1091x638&quality=96&sign=2e6badc1b7732f9c3bb4ab0a068c7216&type=album'
//         ),
//         topLeftCorner: imagePoints.topLeftCorner ?? LatLng(43.103203, 131.915783),
//         bottomLeftCorner: imagePoints.bottomLeftCorner ?? LatLng(43.102356, 131.914743),
//         bottomRightCorner: imagePoints.bottomRightCorner ?? LatLng(43.101359, 131.918377),
//         gaplessPlayback: true,
//       );
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     imagePoints = ImagePoints(null, null, null);
//
//     rotatedOverlayImage = CustomOverlayImage(
//       opacity: opacity,
//       /*imageProvider: const NetworkImage(
//           'https://sun9-29.userapi.com/impg/lTsXSunnPlu1bAL79kEv8de8KVrhQ1mrpvqpCQ/LMHKuZh1pS0.jpg?size=1091x638&quality=96&sign=2e6badc1b7732f9c3bb4ab0a068c7216&type=album'
//       ),*/
//       imageProvider: const NetworkImage(
//           'https://sun9-4.userapi.com/impg/r0TDimJ3iA-WDTxDBu8mfulrelCubU2AhWxC2A/AnBIV6wCffc.jpg?size=638x1091&quality=95&sign=74d21aa3483f5c6f4f452b7d25ea9fb7&type=album'
//       ),
//       topLeftCorner: imagePoints.topLeftCorner ?? LatLng(43.103203, 131.915783),
//       bottomLeftCorner: imagePoints.bottomLeftCorner ?? LatLng(43.102356, 131.914743),
//       bottomRightCorner: imagePoints.bottomRightCorner ?? LatLng(43.101359, 131.918377),
//       gaplessPlayback: true,
//     );
//
//     polyEditor = PolyEditor(
//       addClosePathMarker: true,
//       //points: testPolygon.points,
//       points: imagePointsData,
//       pointIcon: const Icon(Icons.crop_square, size: 10),
//       intermediateIcon: const Icon(Icons.lens, size: 9, color: Colors.black87),
//       callbackRefresh: () => {setState(() {})},
//     );
//
//     controller = MapController();
//
//     ///
//     imageEditor = ImageEditor2(
//       points: imagePointsData,
//       pointIcon: const Icon(Icons.crop_square, size: 15),
//       callbackRefresh: () {
//         setState(() {
//           rotatedOverlayImage.opacity = opacity;
//           rotatedOverlayImage.topLeftCorner = imagePoints.topLeftCorner ?? LatLng(0, 0);
//           rotatedOverlayImage.bottomLeftCorner = imagePoints.bottomLeftCorner ?? LatLng(0, 0);
//           rotatedOverlayImage.bottomRightCorner = imagePoints.bottomRightCorner ?? LatLng(0, 0);
//         });
//       }
//     );
//     ///
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FlutterMap(
//         mapController: controller,
//         options: MapOptions(
//             zoom: 15,
//             maxZoom: 27,
//             center: LatLng(43.175365, 131.907421),
//             onPositionChanged: (position, hasGesture) {
//               ///debugPrint(position.zoom.toString());
//             }
//         ),
//         children: [
//           TileLayer(
//             maxNativeZoom: 18,
//             maxZoom: 25,
//             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//           ),
//           DragMarkers(markers: imageEditor.edit()),
//           GestureDetector(
//             onDoubleTap: () {
//               setState(() {
//                 imageSelected = !imageSelected;
//               });
//
//               print(imageSelected);
//
//               //imageEditor.add(imagePointsData, [imagePoints.topLeftCorner, imagePoints.bottomLeftCorner, imagePoints.bottomRightCorner]);
//             },
//             child: CustomOverlayImageLayer(
//               overlayImages: [
//                 rotatedOverlayImage,
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: SizedBox(
//         width: 200,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Slider(
//               value: opacity,
//               onChanged: (double value) {
//                 setState(() {
//                   opacity = value;
//                 });
//                 refreshImage();
//               }
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }