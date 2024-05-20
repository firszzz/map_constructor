import 'package:geojson_test/data/models/room_data.dart';
import 'package:latlong2/latlong.dart';

class FloorData {
  final List<RoomData> floorRooms;
  List<LatLng> floorLocation = [];
  int floorNum = 0;

  // Добавление нового объекта
  void addRoom(RoomData newRoom) {
    floorRooms.add(newRoom);
  }

  // Изменение координат этажа
  void addFloorLocation(List<LatLng> newFloorLocation) {
    floorLocation = newFloorLocation;
  }

  FloorData(this.floorRooms, this.floorLocation, this.floorNum);
}