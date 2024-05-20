import 'package:latlong2/latlong.dart';
import 'floor_data.dart';

class BuildingData {
  String? buildingName;
  final List<LatLng> buildingLocation;
  final List<FloorData> buildingFloors;

  BuildingData(this.buildingName, this.buildingLocation, this.buildingFloors);
}