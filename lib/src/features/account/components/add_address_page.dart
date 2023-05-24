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
        scrolledUnderElevation: 5,
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
                    'editUserInfo'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10.0),
                  RegularCard(
                    highlightRed: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextHeader(
                            headerText: 'Enter Your Address Name',
                            fontSize: 18),
                        TextFormFieldRegular(
                          labelText: 'Address Name'.tr,
                          hintText: 'Example : Home'.tr,
                          prefixIconData: Icons.person,
                          textController: controller.locationNameTextController,
                          inputType: InputType.text,
                          editable: true,
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                    ),
                  ),
                  RegularCard(
                    highlightRed: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextHeader(
                            headerText: 'Enter Your Address', fontSize: 18),
                        TextFormFieldRegular(
                          labelText: 'address'.tr,
                          hintText: 'Example: 6 ش عبد المجيد'.tr,
                          prefixIconData: Icons.email,
                          textController: controller.addressesTextController,
                          inputType: InputType.text,
                          editable: true,
                          textInputAction: TextInputAction.next,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: RegularElevatedButton(
                            buttonText: 'save'.tr,
                            onPressed: () {},
                            enabled: true,
                            color: kDefaultColor,
                          ),
                        ),
                      ],
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
