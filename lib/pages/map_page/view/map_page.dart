import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:special_phone_book/pages/map_page/controller/map_page_controller.dart';
import 'package:special_phone_book/pages/widgets/app_bar.dart';
import 'package:special_phone_book/pages/widgets/back_button.dart';
import 'package:special_phone_book/pages/widgets/custom_button.dart';
import 'package:special_phone_book/pages/widgets/custom_text.dart';

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
    Get.put(MapPageController(pointData: Get.arguments ?? {'edit': true}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<MapPageController>(builder: (mapPageController) {
        return Material(
          child: Column(
            children: [
              if (Get.arguments['edit']) ...{
                const CustomAppBar(
                  title: 'انتخاب آدرس',
                  trailing: [
                    Spacer(),
                    CustomButton(
                      onTap: onLocationSubmitTap,
                      maxSize: Size(40, 40),
                      isFlat: true,
                      child: Icon(CupertinoIcons.check_mark),
                    )
                  ],
                  leading: [CustomBackButton(), Spacer()],
                ),
              },
              Expanded(
                child: FlutterMap(
                  mapController: mapPageController.mapController,
                  options: MapOptions(
                    initialCenter: mapPageController.initPoint, // Center the map over Tehran
                    initialZoom: mapPageController.initZoom,
                    minZoom: 3,
                    maxZoom: 18,
                    onPositionChanged: (camera, hasGesture) {
                      if (Get.arguments['edit']) {
                        mapPageController.setSelectedPoint(camera.center);
                      }
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
                            point: mapPageController.selectedPoint),
                      ],
                    ),
                    if (!Get.arguments['edit']) ...{
                      Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomButton(
                            onTap: () => MapsLauncher.launchCoordinates(
                                mapPageController.selectedPoint.latitude,
                                mapPageController.selectedPoint.longitude),
                            maxSize: const Size(200, 40),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.map_rounded),
                                SizedBox(width: 5),
                                CustomText(
                                  text: 'مسیر یابی در گوگل مپ',
                                  color: Color(0xff78c7bc),
                                ),
                              ],
                            )),
                      ),
                    ),
                    }
                    
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
