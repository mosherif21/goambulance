import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/common_widgets/regular_elevated_button.dart';
import 'package:goambulance/src/constants/no_localization_strings.dart';
import 'package:goambulance/src/constants/sizes.dart';
import 'package:goambulance/src/features/authentication/screens/login_screen.dart';
import 'package:goambulance/src/general/common_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../constants/app_init_constants.dart';
import '../../../error_widgets/not_available_error_widget.dart';

class HomePageScreen extends StatelessWidget {
  HomePageScreen({Key? key}) : super(key: key) {
    if (!AppInit.isWeb) getPolyPoints();
  }

  //final Completer<GoogleMapController> _googleMapController = Completer();
  static const LatLng _sourceLocation =
      LatLng(31.231448746766013, 29.95178427810977);
  static const LatLng _place2 = LatLng(31.223958388803208, 29.93226379758089);
  final polylineCoordinates = <LatLng>[].obs;

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
      googleMapsAPIKey,
      PointLatLng(_sourceLocation.latitude, _sourceLocation.longitude),
      PointLatLng(_place2.latitude, _place2.longitude),
    );
    if (polylineResult.points.isNotEmpty) {
      for (var point in polylineResult.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = getScreenHeight(context);
    return AppInit.isWeb
        ? const NotAvailableErrorWidget()
        : Scaffold(
            body: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(kDefaultPaddingSize),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(
                      () => SizedBox(
                        height: screenHeight * 0.8,
                        child: GoogleMap(
                          initialCameraPosition: const CameraPosition(
                              target: _sourceLocation, zoom: 14.5),
                          polylines: {
                            Polyline(
                                polylineId: const PolylineId("route test"),
                                points: polylineCoordinates.value,
                                width: 3),
                          },
                          markers: {
                            const Marker(
                                markerId: MarkerId("My Home"),
                                position: _sourceLocation),
                            const Marker(
                                markerId: MarkerId("place test"),
                                position: _place2)
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    RegularElevatedButton(
                        buttonText: 'logout'.tr,
                        onPressed: () async {
                          await AuthenticationRepository.instance
                              .logoutUser()
                              .then((value) =>
                                  Get.offAll(() => const LoginScreen()));
                        },
                        enabled: true),
                  ],
                ),
              ),
            ),
          );
  }
}
