import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:special_phone_book/routes/routes.dart';

// ignore: must_be_immutable
class AddressTile extends StatelessWidget {
  AddressTile(
      {super.key,
      required this.coordinate,
      required this.coordinateIndex,
      required this.isEditing,
      this.onCloseTap});

  final LatLng coordinate;
  final int coordinateIndex;
  final bool isEditing;
  final VoidCallback? onCloseTap;

  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Badge(
      padding: const EdgeInsets.all(2),
      alignment: Alignment.topRight,
      label: InkWell(
          onTap: onCloseTap, child: const Icon(Icons.close_rounded, color: Colors.white, size: 18)),
      isLabelVisible: isEditing,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),),
        child: Card(
          margin: const EdgeInsets.all(0),
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
            
                    initialCameraFit: CameraFit.coordinates(coordinates: [coordinate]),
                    initialCenter: coordinate, // Center the map over Tehran
                    initialZoom: 15,
                    minZoom: 15,
                    maxZoom: 15,
                    interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                    onTap: (a, b) => routeToPage(page: Routes.mapPage, arguments: {
                          'latitude': coordinate.latitude,
                          'longitude': coordinate.longitude,
                          'index': coordinateIndex,
                          'edit': isEditing
                        })),
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
                          point: coordinate),
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
