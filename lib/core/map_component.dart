import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapComponent extends StatelessWidget {
  const MapComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Future<BitmapDescriptor> getMarkerAsset(String assetName) async {
      return BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
          size: Size.fromRadius(5),
        ),
        assetName,
      );
    }

    return FutureBuilder(
      future: getMarkerAsset('assets/onboarding_one.png'),
      builder: (context, snapshot) {
        // ignore: unused_local_variable
        final BitmapDescriptor icon =
            snapshot.data ?? BitmapDescriptor.defaultMarker;
        return StreamBuilder(
          stream: Geolocator.getPositionStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    width: 50,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              );
            } else {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    snapshot.data!.latitude,
                    snapshot.data!.longitude,
                  ),
                  zoom: 17,
                ),
                mapType: MapType.normal,
                markers: {
                  Marker(
                    markerId: const MarkerId("Me"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: LatLng(
                      snapshot.data!.latitude,
                      snapshot.data!.longitude,
                    ),
                  )
                  // Marker(
                  //   markerId: const MarkerId("Me"),
                  //   icon: icon,
                  //   position: LatLng(
                  //     snapshot.data?.latitude ?? 0,
                  //     snapshot.data?.longitude ?? 0,
                  //   ),
                  // ),
                },
              );
            }
          },
        );
      },
    );
  }
}
