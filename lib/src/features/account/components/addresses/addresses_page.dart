import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/components/addresses/address_item.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';
import 'package:goambulance/src/general/general_functions.dart';

import '../../../../connectivity/connectivity.dart';
import '../../../../general/common_widgets/rounded_elevated_button.dart';
import '../../controllers/addresses_controller.dart';
import 'address_location_page.dart';
import 'loading_addresses.dart';
import 'no_addresses_saved.dart';

class AccountAddressesPage extends StatelessWidget {
  const AccountAddressesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectivityChecker.checkConnection(displayAlert: true);
    final controller = Get.put(AddressesController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'addresses'.tr,
          maxLines: 1,
        ),
        titleTextStyle: const TextStyle(
            fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => SingleChildScrollView(
                      child: !controller.addressesLoaded.value
                          ? const LoadingAddresses()
                          : controller.addressesList.isNotEmpty
                              ? Column(
                                  children: [
                                    for (var addressItem
                                        in controller.addressesList)
                                      Obx(
                                        () => LoadAddressItem(
                                          addressItem: addressItem,
                                          onDeletePressed: () =>
                                              controller.removeAddress(
                                                  addressItem: addressItem),
                                          isPrimary: controller
                                                  .primaryAddressIndex.value ==
                                              controller.addressesList
                                                  .indexOf(addressItem),
                                          onEditPressed: () =>
                                              controller.editAddress(
                                                  addressItem: addressItem),
                                        ),
                                      ),
                                  ],
                                )
                              : const NoAddressesSaved(),
                    ),
                  ),
                  RoundedElevatedButton(
                    buttonText: 'addAddress'.tr,
                    onPressed: () => Get.to(() => const AddressLocationPage(),
                        transition: getPageTransition()),
                    enabled: true,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
