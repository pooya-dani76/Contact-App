// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'package:special_phone_book/pages/edit_page/controller/edit_page_controller.dart';

class MapPageController extends GetxController {
  LatLng initPoint = const LatLng(35.715298, 51.404343);
  LatLng selectedPoint = const LatLng(35.715298, 51.404343);
  MapController mapController = MapController();
  double initZoom = 10;
  Map pointData;
  MapPageController({
    required this.pointData,
  });

  @override
  onInit() {
    loadPointData();
    super.onInit();
  }

  setSelectedPoint(LatLng value) {
    selectedPoint = value;
    update();
  }

  loadPointData() {
    if (pointData.containsKey('latitude')) {
      initPoint = LatLng(pointData['latitude'], pointData['longitude']);
      selectedPoint = LatLng(pointData['latitude'], pointData['longitude']);
      initZoom = 15;
      update();
    }
  }
}

void onLocationSubmitTap() {
  EditPageController editPageController = Get.find();
  MapPageController mapPageController = Get.find();

  if (mapPageController.pointData.containsKey('latitude')) {
    editPageController.editAddress(
        index: mapPageController.pointData['index'],
        latitude: mapPageController.selectedPoint.latitude,
        longitude: mapPageController.selectedPoint.longitude);
  } else {
    editPageController.addAddress(
        latitude: mapPageController.selectedPoint.latitude,
        longitude: mapPageController.selectedPoint.longitude);
  }
  Get.back();
}
