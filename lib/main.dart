import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geojson_test/map_constructor/data/image_editor/image_editor_test.dart';
import 'package:geojson_test/map_constructor/ui/image_editor_widget.dart';
import 'package:geojson_test/polymap.dart';
import 'package:geojson_test/twopolymap.dart';

import 'map_constructor/data/image_editor/image_editor_test.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ImageEditorWidget(),
      debugShowCheckedModeBanner: false,
    ),
  );
}