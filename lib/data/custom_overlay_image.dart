// import 'package:flutter/widgets.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map/src/map/flutter_map_state.dart';
// import 'package:flutter_map/src/core/bounds.dart';
// import 'package:latlong2/latlong.dart';
//
// /// Base class for all overlay images.
// abstract class BaseOverlayImage {
//   ImageProvider get imageProvider;
//
//   double get opacity;
//
//   bool get gaplessPlayback;
//
//   Positioned buildPositionedForOverlay(FlutterMapState map);
//
//   Image buildImageForOverlay() {
//     return Image(
//       image: imageProvider,
//       fit: BoxFit.fill,
//       color: Color.fromRGBO(255, 255, 255, opacity),
//       colorBlendMode: BlendMode.modulate,
//       gaplessPlayback: gaplessPlayback,
//     );
//   }
// }
//
// class CustomOverlayImage extends BaseOverlayImage {
//   @override
//   final ImageProvider imageProvider;
//
//   LatLng topLeftCorner, bottomLeftCorner, bottomRightCorner;
//
//   @override
//   double opacity;
//
//   @override
//   final bool gaplessPlayback;
//
//   /// The filter quality when rotating the image.
//   final FilterQuality? filterQuality;
//
//   CustomOverlayImage(
//       {required this.imageProvider,
//         required this.topLeftCorner,
//         required this.bottomLeftCorner,
//         required this.bottomRightCorner,
//         this.opacity = 1.0,
//         this.gaplessPlayback = false,
//         this.filterQuality = FilterQuality.medium});
//
//   @override
//   Positioned buildPositionedForOverlay(FlutterMapState map) {
//     final pxTopLeft = map.project(topLeftCorner) - map.pixelOrigin;
//     final pxBottomRight = map.project(bottomRightCorner) - map.pixelOrigin;
//     final pxBottomLeft = map.project(bottomLeftCorner) - map.pixelOrigin;
//     // calculate pixel coordinate of top-right corner by calculating the
//     // vector from bottom-left to top-left and adding it to bottom-right
//     final pxTopRight = (pxTopLeft - pxBottomLeft + pxBottomRight);
//
//     // update/enlarge bounds so the new corner points fit within
//     final bounds = Bounds<num>(pxTopLeft, pxBottomRight)
//         .extend(pxTopRight)
//         .extend(pxBottomLeft);
//
//     final vectorX = (pxTopRight - pxTopLeft) / bounds.size.x;
//     final vectorY = (pxBottomLeft - pxTopLeft) / bounds.size.y;
//     final offset = pxTopLeft - bounds.topLeft;
//
//     final a = vectorX.x.toDouble();
//     final b = vectorX.y.toDouble();
//     final c = vectorY.x.toDouble();
//     final d = vectorY.y.toDouble();
//     final tx = offset.x.toDouble();
//     final ty = offset.y.toDouble();
//
//     return Positioned(
//         left: bounds.topLeft.x.toDouble(),
//         top: bounds.topLeft.y.toDouble(),
//         width: bounds.size.x.toDouble(),
//         height: bounds.size.y.toDouble(),
//         child: Transform(
//             transform:
//             Matrix4(a, b, 0, 0, c, d, 0, 0, 0, 0, 1, 0, tx, ty, 0, 1),
//             filterQuality: filterQuality,
//             child: buildImageForOverlay()));
//   }
// }
//
// class CustomOverlayImageLayer extends StatelessWidget {
//   final List<BaseOverlayImage> overlayImages;
//
//   const CustomOverlayImageLayer({super.key, this.overlayImages = const []});
//
//   @override
//   Widget build(BuildContext context) {
//     final map = FlutterMapState.of(context);
//     return ClipRect(
//       child: Stack(
//         children: <Widget>[
//           for (var overlayImage in overlayImages)
//             overlayImage.buildPositionedForOverlay(map),
//         ],
//       ),
//     );
//   }
// }
