import 'package:crea_radio_button/crea_radio_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/constants/colors.dart';
import 'package:goambulance/src/features/account/controllers/register_user_data_controller.dart';
import 'package:goambulance/src/general/common_functions.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';
import 'package:goambulance/src/general/common_widgets/text_form_field.dart';
import 'package:goambulance/src/general/common_widgets/text_header.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../../firebase_files/firebase_access.dart';

class RegisterUserDataPage extends StatelessWidget {
  const RegisterUserDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(FirebaseDataAccess());
    final controller = Get.put(RegisterUserDataController());
    //final screenHeight = getScreenHeight(context);
    return WillPopScope(
      onWillPop: () async {
        await logout();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomBackButton(
                    onPressed: () async => await logout(),
                    buttonText: 'logout'.tr,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'enterYourInfo'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextHeader(headerText: 'enterFullName'.tr, fontSize: 18),
                  TextFormFieldRegular(
                    labelText: 'fullName'.tr,
                    hintText: 'enterFullName'.tr,
                    prefixIconData: Icons.person,
                    textController: controller.nameTextController,
                    inputType: InputType.text,
                    editable: true,
                  ),
                  const SizedBox(height: 10.0),
                  TextHeader(headerText: 'emailHintLabel'.tr, fontSize: 18),
                  TextFormFieldRegular(
                    labelText: 'emailLabel'.tr,
                    hintText: 'emailHintLabel'.tr,
                    prefixIconData: Icons.email,
                    textController: controller.emailTextController,
                    inputType: InputType.text,
                    editable: controller.emailTextController.text.isNotEmpty
                        ? false
                        : true,
                  ),
                  const SizedBox(height: 10.0),
                  TextHeader(headerText: 'enterNationalId'.tr, fontSize: 18),
                  TextFormFieldRegular(
                    labelText: 'nationalId'.tr,
                    hintText: 'enterNationalId'.tr,
                    prefixIconData: FontAwesomeIcons.idCard,
                    textController: controller.nationalIdTextController,
                    inputType: InputType.text,
                    editable: true,
                  ),
                  const SizedBox(height: 10.0),
                  TextHeader(headerText: 'enterGender'.tr, fontSize: 18),
                  RadioButtonGroup(
                    buttonHeight: 40,
                    buttonWidth: 140,
                    circular: true,
                    mainColor: Colors.grey,
                    selectedColor: kDefaultColorLessShade,
                    unselectEnabled: true,
                    options: [
                      RadioOption(Gender.male, 'male'.tr),
                      RadioOption(Gender.female, 'female'.tr),
                    ],
                    callback: (RadioOption radioValue) => controller.gender =
                        radioValue.value == Gender.male ? 'male' : 'female',
                  ),
                  const SizedBox(height: 10.0),
                  TextHeader(headerText: 'enterBirthDate'.tr, fontSize: 18),
                  Container(
                    decoration: const BoxDecoration(
                      color: kDefaultColorLessShade,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: SfDateRangePicker(
                      controller: controller.birthDateController,
                      selectionMode: DateRangePickerSelectionMode.single,
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
