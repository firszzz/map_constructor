import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';

import 'package:geojson_test/map_constructor/data/editor/image_editor.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:image_picker/image_picker.dart';

class ImageEditorWidget extends StatefulWidget {
  const ImageEditorWidget({super.key});

  @override
  State<ImageEditorWidget> createState() => _ImageEditorWidgetState();
}

class _ImageEditorWidgetState extends State<ImageEditorWidget> {
  late MapController controller;
  LatLng? controllerCenter;

  late ImageEditor imageEditor;

  double opacity = 0.75;
  
  File? pickedImage;
  Uint8List? webImage;

  bool imageSelected = false;

  RotatedOverlayImage? rotatedOverlayImage;

  List<LatLng> imagePoints = [];

  @override
  void initState() {
    controller = MapController();
    super.initState();
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setState(() {
          pickedImage = selected;
        });
      } else {
        debugPrint('no image has been picked');
      }
    } else if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = await image.readAsBytes();

        setState(() {
          webImage = selected;
          pickedImage = File('nothing');
        });
      } else {
        debugPrint('no image has been picked');
      }
    } else {
      debugPrint('not mobile and web version used.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: controller,
        options: const MapOptions(
          initialCenter: LatLng(43.10335281021071, 131.91045757173578),
          initialZoom: 15,
          maxZoom: 25,
        ),
        children: [
          TileLayer(
            tileProvider: CancellableNetworkTileProvider(),
            maxNativeZoom: 20,
            maxZoom: 35,
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          (webImage != null && rotatedOverlayImage != null && imageSelected) ? DragMarkers(markers: imageEditor.edit()) : SizedBox(),
          (webImage != null && rotatedOverlayImage != null) ? GestureDetector(
            onDoubleTap: () {
              setState(() {
                imageSelected = !imageSelected;
              });
            },
            child: OverlayImageLayer(
              overlayImages: [
                rotatedOverlayImage!
              ],
            ),
          ) : const SizedBox(height: 10, width: 10),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          webImage != null ? RotatedBox(
            quarterTurns: 3,
            child: SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Slider(
                    min: 0.01,
                    max: 0.99,
                    value: opacity,
                    onChanged: (double value) {
                      setState(() {
                        opacity = value;
                      });
                      imageEditor.callbackRefresh!();
                    }
                  )
                ],
              ),
            ),
          ): const SizedBox(),
          const SizedBox(height: 20),
          webImage != null ? FloatingActionButton(
            child: const Icon(Icons.image_not_supported_outlined),
            onPressed: () {
              setState(() {
                webImage = null;
                opacity = 0.75;
              });
            },
          ) : const SizedBox(),
          const SizedBox(height: 20),
          FloatingActionButton(
            child: const Icon(Icons.image_search),
            onPressed: () async {
              await _pickImage();

              controllerCenter = controller.camera.center;

              setState(() {
                imagePoints = [
                  controllerCenter!,
                  LatLng(controllerCenter!.latitude, controllerCenter!.longitude + 0.002),
                  LatLng(controllerCenter!.latitude + 0.002, controllerCenter!.longitude + 0.002)
                ];

                rotatedOverlayImage = RotatedOverlayImage(
                  imageProvider: MemoryImage(webImage!),
                  opacity: opacity,
                  topLeftCorner: imagePoints[0],
                  bottomLeftCorner: imagePoints[1],
                  bottomRightCorner: imagePoints[2],
                );
              });

              imageEditor = ImageEditor(
                points: imagePoints,
                callbackRefresh: () => {
                  setState(() {
                    rotatedOverlayImage = RotatedOverlayImage(
                      imageProvider: MemoryImage(webImage!),
                      opacity: opacity,
                      topLeftCorner: imagePoints[0],
                      bottomLeftCorner: imagePoints[1],
                      bottomRightCorner: imagePoints[2],
                    );
                  })
                }
              );
            }
          ),
        ],
      )
    );
  }
}
