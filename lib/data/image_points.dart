import 'package:latlong2/latlong.dart';

class ImagePoints {
  LatLng? topLeftCorner, bottomLeftCorner, bottomRightCorner;

  ImagePoints(this.topLeftCorner, this.bottomLeftCorner, this.bottomRightCorner);

  setImages(tlc, blc, brc) {
    topLeftCorner = tlc;
    bottomLeftCorner = blc;
    bottomRightCorner = brc;
  }

  List<LatLng> getImagePoints() {
    if (topLeftCorner != null && bottomLeftCorner != null && bottomRightCorner != null) {
      return [topLeftCorner!, bottomLeftCorner!, bottomRightCorner!];
    }

    return [];
  }
}