import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/colors.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';
import 'package:goambulance/src/general/common_widgets/regular_elevated_button.dart';
import 'package:goambulance/src/general/common_widgets/text_form_field.dart';
import 'package:goambulance/src/general/common_widgets/text_header.dart';

import '../../../../constants/enums.dart';
import '../../../../general/common_widgets/custom_rolling_switch.dart';
import '../../../../general/common_widgets/regular_card.dart';
import '../../controllers/addresses_controller.dart';

class AddAddressPage extends StatelessWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = AddressesController.instance;
    return Scaffold(
      appBar: AppBar(
        leading: const RegularBackButton(padding: 0),
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
      ),
      backgroundColor: Colors.grey.shade100,
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
                    () => RegularCard(
                      highlightRed: controller.highlightLocationName.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextHeader(
                              headerText: 'enterAddressName'.tr, fontSize: 18),
                          TextFormFieldRegular(
                            labelText: 'addressName'.tr,
                            hintText: 'addNameExample'.tr,
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
                          TextHeader(
                              headerText: 'enterStreet'.tr, fontSize: 18),
                          TextFormFieldRegular(
                            labelText: 'streetName'.tr,
                            hintText: 'streetExample'.tr,
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
                          TextHeader(
                              headerText: 'enterApartmentNumber'.tr,
                              fontSize: 18),
                          TextFormFieldRegular(
                            labelText: 'apartmentNumberText'.tr,
                            hintText: 'apartmentNumberExample'.tr,
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
                          TextHeader(
                              headerText: 'enterFloorNumber'.tr, fontSize: 18),
                          TextFormFieldRegular(
                            labelText: 'floorNumberText'.tr,
                            hintText: 'floorNumberExample'.tr,
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
                          TextHeader(
                              headerText: 'enterAreaName'.tr, fontSize: 18),
                          TextFormFieldRegular(
                            labelText: 'areaName'.tr,
                            hintText: 'areaNameExample'.tr,
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
                        TextHeader(
                            headerText: 'enterAdditionalInformation'.tr,
                            fontSize: 18),
                        TextFormFieldRegular(
                          labelText: 'additionalInformation'.tr,
                          hintText: 'additionalInfoExample'.tr,
                          prefixIconData: Icons.info,
                          textController:
                              controller.additionalInfoTextController,
                          inputType: InputType.text,
                          editable: true,
                          textInputAction: TextInputAction.done,
                        ),
                      ],
                    ),
                  ),
                  RegularCard(
                    highlightRed: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHeader(
                            headerText: 'makePrimaryText'.tr, fontSize: 18),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Spacer(),
                            CustomRollingSwitch(
                              onText: 'yes'.tr,
                              offText: 'no'.tr,
                              onIcon: Icons.check,
                              offIcon: Icons.close,
                              onSwitched: (bool state) =>
                                  controller.makePrimary = state,
                              keyInternal: controller.makePrimaryKey,
                            ),
                          ],
                        )
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
