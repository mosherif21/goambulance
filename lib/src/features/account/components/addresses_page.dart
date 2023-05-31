import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/components/add_address_page.dart';
import 'package:goambulance/src/features/account/components/address_item.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';

import '../../../general/common_widgets/rounded_elevated_button.dart';
import '../controllers/addresses_controller.dart';
import 'loading_addresses.dart';
import 'no_addresses_saved.dart';

class AccountAddressesPage extends StatelessWidget {
  const AccountAddressesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressesController());
    return Scaffold(
      appBar: AppBar(
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'addresses'.tr,
          maxLines: 1,
        ),
        titleTextStyle: const TextStyle(
            fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => SingleChildScrollView(
                        child: !controller.addressesLoaded.value
                            ? const LoadingAddresses()
                            : controller.addressesList.isNotEmpty
                                ? Column(
                                    children: [
                                      for (var addressItem
                                          in controller.addressesList)
                                        LoadAddressItem(
                                            addressItem: addressItem,
                                            onDeletePressed: () =>
                                                controller.removeAddress(
                                                    addressItem: addressItem)),
                                    ],
                                  )
                                : const NoAddressesSaved(),
                      )),
                  RoundedElevatedButton(
                      buttonText: 'Add New Address',
                      onPressed: () {
                        Get.to(const AddAddressPage());
                      },
                      enabled: true,
                      color: Colors.indigo)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
