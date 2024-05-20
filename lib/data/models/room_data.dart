import 'package:latlong2/latlong.dart';

class RoomData {
  String? roomName; // Room в данном случае это не только помещение, но и может быть стена, поэтому отображать название не нужно /// TODO: мб нужно будет иконку добавить тогда
  List<LatLng> roomLocation = [];
  int roomFloor = 0;

  RoomData(this.roomName, this.roomLocation, this.roomFloor);
}