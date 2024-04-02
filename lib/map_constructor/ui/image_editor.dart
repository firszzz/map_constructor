import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:image_picker/image_picker.dart';

class ImageEditor extends StatefulWidget {
  const ImageEditor({super.key});

  @override
  State<ImageEditor> createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  late MapController controller;
  LatLng? controllerCenter;
  
  File? pickedImage;
  Uint8List? webImage;

  @override
  void initState() {
    super.initState();

    controller = MapController();
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
          webImage != null ? OverlayImageLayer(
            overlayImages: [
              OverlayImage(
                imageProvider: MemoryImage(webImage!),
                bounds: LatLngBounds(
                  controllerCenter!,
                  LatLng(controllerCenter!.latitude + 0.001, controllerCenter!.longitude + 0.002)
                ),
                opacity: 0.75,
                gaplessPlayback: true,
              )
            ],
          ) : const SizedBox()
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          webImage != null ? FloatingActionButton(
            child: const Icon(Icons.image_not_supported_outlined),
            onPressed: () {
              setState(() {
                webImage = null;
              });
            },
          ) : const SizedBox(),
          const SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            child: const Icon(Icons.image_search),
            onPressed: () {
              _pickImage();
              controllerCenter = controller.camera.center;
            },
          ),
        ],
      )
    );
  }
}
