import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/components/add_address_page.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';

import '../../../general/common_widgets/rounded_elevated_button.dart';
import '../controllers/addresses_controller.dart';
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
        scrolledUnderElevation: 5,
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
                  const NoAddressesSaved(),
                  RoundedElevatedButton(
                      buttonText: 'Add New Address',
                      onPressed: () {
                        Get.to(const AddAddressPage());
                      },
                      enabled: true,
                      color: Colors.indigo)
                  // Obx(() =>
                  //     RegularCard(highlightRed: false, child: SingleChildScrollView(child:!controller.diseasesLoaded.value
                  //         ? const LoadingAddresses()
                  //         : controller.addressesList.isNotEmpty
                  //         ? Column(
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.all(8),
                  //           child: AutoSizeText(
                  //             'addedDiseases'.tr,
                  //             style: const TextStyle(
                  //               fontSize: 18,
                  //               fontWeight: FontWeight.w800,
                  //             ),
                  //             maxLines: 2,
                  //           ),
                  //         ),
                  //         const SizedBox(height: 10),
                  //         for (var diseaseItem
                  //         in controller.addressesList)
                  //           MedicalHistoryItem(
                  //             diseaseItem: diseaseItem,
                  //             onDeletePressed: () => controller
                  //                 .diseasesList
                  //                 .remove(diseaseItem),
                  //           ),
                  //         Padding(
                  //           padding: const EdgeInsets.only(
                  //               left: 15.0, right: 15.0),
                  //           child: RoundedElevatedButton(
                  //             buttonText:
                  //             'addAllergiesOrDiseases'.tr,
                  //             onPressed: () => RegularBottomSheet
                  //                 .showRegularBottomSheet(
                  //               AddDisease(controller: controller),
                  //             ),
                  //             enabled: true,
                  //             color: Colors.black,
                  //           ),
                  //         ),
                  //       ],
                  //     )
                  //         : NoMedicalHistory(controller: controller),,)))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
