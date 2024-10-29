import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapPageController extends GetxController {
  LatLng point = const LatLng(35.715298, 51.404343);
  LatLng? selectedPoint;
  MapController mapController = MapController();

  setSelectedPoint(LatLng value){
    selectedPoint = value;
    update();
  }
}