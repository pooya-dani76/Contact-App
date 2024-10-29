import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/pages/map_page/controller/map_page_controller.dart';
import 'package:special_phone_book/pages/widgets/app_bar.dart';
import 'package:special_phone_book/pages/widgets/back_button.dart';
import 'package:special_phone_book/pages/widgets/custom_button.dart';

// ignore: must_be_immutable
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void dispose() {
    MapPageController mapPageController = Get.find();
    mapPageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Get.put(MapPageController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<MapPageController>(builder: (mapPageController) {
        return Material(
          child: Column(
            children: [
              CustomAppBar(
                title: 'انتخاب آدرس',
                trailing: [
                  const Spacer(),
                  CustomButton(
                    onTap: () {},
                    maxSize: const Size(50,50),
                    isFlat: true,
                    child: const Icon(CupertinoIcons.check_mark),
                  )
                ],
                leading: const [CustomBackButton(), Spacer()],
              ),
              Expanded(
                child: FlutterMap(
                  mapController: mapPageController.mapController,
                  options: MapOptions(
                    initialCenter: mapPageController.point, // Center the map over Tehran
                    initialZoom: 3,
                    minZoom: 3,
                    maxZoom: 18,
                    onPositionChanged: (camera, hasGesture) {
                      mapPageController.setSelectedPoint(camera.center);
                    },
                    interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag),
                  ),
                  children: [
                    TileLayer(
                      // Display map tiles from any source
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
                      userAgentPackageName: 'com.example.app',
                      // And many more recommended properties!
                    ),
                    MarkerLayer(
                      alignment: Alignment.topCenter,
                      markers: [
                        Marker(
                            child: const Icon(
                              CupertinoIcons.location_solid,
                              color: Colors.red,
                              size: 40,
                            ),
                            point: mapPageController.selectedPoint ?? mapPageController.point),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
