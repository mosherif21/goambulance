import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../general/general_functions.dart';
import '../../../requests/components/general/location_inaccessible.dart';
import '../../controllers/address_location_controller.dart';
import 'address_map_page.dart';

class AddressLocationPage extends StatelessWidget {
  const AddressLocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final addressLocationController = Get.put(AddressesLocationController());
    return Obx(
      () => addressLocationController.mapEnabled.value
          ? AddressMapPage(
              addressLocationController: addressLocationController,
            )
          : LocationInaccessible(
              locationController: addressLocationController,
              screenHeight: screenHeight,
            ),
    );
  }
}
