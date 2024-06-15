import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:interactive_bottom_sheet/interactive_bottom_sheet.dart';

class HomeController extends GetxController {
  RxInt funCount = 0.obs;

  void increment() {
    funCount.value++;
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<BitmapDescriptor> _getMarkerAsset(String assetName) async {
    return BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        size: Size.fromRadius(5),
      ),
      assetName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomSheet: InteractiveBottomSheet(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text("Hello"),
            ),
          ),
          draggableAreaOptions: DraggableAreaOptions(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            indicatorColor: Theme.of(context).colorScheme.primary,
          ),
          options: InteractiveBottomSheetOptions(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        body: FutureBuilder(
          future: _getMarkerAsset('assets/onboarding_one.png'),
          builder: (context, snapshot) {
            final BitmapDescriptor icon =
                snapshot.data ?? BitmapDescriptor.defaultMarker;

            return StreamBuilder(
              stream: Geolocator.getPositionStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
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
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    markers: {
                      Marker(
                        markerId: const MarkerId("Me"),
                        icon: icon,
                        position: LatLng(
                          snapshot.data?.latitude ?? 0,
                          snapshot.data?.longitude ?? 0,
                        ),
                      ),
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
