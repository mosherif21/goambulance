import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/colors.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';
import 'package:goambulance/src/general/common_widgets/regular_elevated_button.dart';
import 'package:goambulance/src/general/common_widgets/text_form_field.dart';
import 'package:goambulance/src/general/common_widgets/text_header.dart';

import '../../../connectivity/connectivity.dart';
import '../../../constants/enums.dart';
import '../../../general/common_widgets/regular_card.dart';
import '../controllers/addresses_controller.dart';

class AddAddressPage extends StatelessWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectivityChecker.checkConnection(displayAlert: true);
    final controller = Get.put(AddressesController());

    return Scaffold(
      appBar: AppBar(
        leading: const RegularBackButton(padding: 0),
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: Colors.grey.shade100,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'addAddressTitle'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10.0),
                  Obx(
                    () => RegularCard(
                      highlightRed: controller.highlightLocationName.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextHeader(
                              headerText: 'Enter Your Address Name',
                              fontSize: 18),
                          TextFormFieldRegular(
                            labelText: 'Address Name'.tr,
                            hintText: 'Example : Home'.tr,
                            prefixIconData: Icons.home_work,
                            textController:
                                controller.locationNameTextController,
                            inputType: InputType.text,
                            editable: true,
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () => RegularCard(
                      highlightRed: controller.highlightStreetName.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextHeader(
                              headerText: 'Enter Your Street Name',
                              fontSize: 18),
                          TextFormFieldRegular(
                            labelText: 'Street Name'.tr,
                            hintText: 'Example : Abu kir'.tr,
                            prefixIconData: Icons.add_road,
                            textController: controller.streetNameTextController,
                            inputType: InputType.text,
                            editable: true,
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () => RegularCard(
                      highlightRed: controller.highlightApartmentNumber.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextHeader(
                              headerText: 'Enter Your Apartment Number',
                              fontSize: 18),
                          TextFormFieldRegular(
                            labelText: 'Apartment Number'.tr,
                            hintText: 'Example : 6'.tr,
                            prefixIconData: Icons.house,
                            textController:
                                controller.apartmentNumberTextController,
                            inputType: InputType.text,
                            editable: true,
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () => RegularCard(
                      highlightRed: controller.highlightFloorNumber.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextHeader(
                              headerText: 'Enter Your Floor Number',
                              fontSize: 18),
                          TextFormFieldRegular(
                            labelText: 'Floor Number'.tr,
                            hintText: 'Example : 1002'.tr,
                            prefixIconData: Icons.numbers,
                            textController:
                                controller.floorNumberTextController,
                            inputType: InputType.text,
                            editable: true,
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () => RegularCard(
                      highlightRed: controller.highlightArea.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextHeader(
                              headerText: 'Enter Your Area Name', fontSize: 18),
                          TextFormFieldRegular(
                            labelText: 'address'.tr,
                            hintText: 'Example: Smouha'.tr,
                            prefixIconData: Icons.map,
                            textController: controller.areaNameTextController,
                            inputType: InputType.text,
                            editable: true,
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),
                    ),
                  ),
                  RegularCard(
                    highlightRed: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextHeader(
                            headerText: 'Enter Any Additional Information',
                            fontSize: 18),
                        TextFormFieldRegular(
                          labelText: 'Additional Information'.tr,
                          hintText:
                              'Example : there is a pharmacy under the building '
                                  .tr,
                          prefixIconData: Icons.info,
                          textController:
                              controller.additionalInfoTextController,
                          inputType: InputType.text,
                          editable: true,
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: RegularElevatedButton(
                      buttonText: 'save'.tr,
                      onPressed: () {
                        controller.checkAddress();
                      },
                      enabled: true,
                      color: kDefaultColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
