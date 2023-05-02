import 'package:auto_size_text/auto_size_text.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/colors.dart';
import 'package:goambulance/src/features/account/components/newAccount/photo_select.dart';
import 'package:goambulance/src/features/account/controllers/register_user_data_controller.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';
import 'package:goambulance/src/general/common_widgets/regular_elevated_button.dart';
import 'package:goambulance/src/general/common_widgets/text_form_field.dart';
import 'package:goambulance/src/general/common_widgets/text_header.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../../firebase_files/firebase_patient_access.dart';
import '../../../../connectivity/connectivity.dart';
import '../../../../constants/enums.dart';
import '../../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../../general/common_widgets/regular_card.dart';

class RegisterUserDataPage extends StatelessWidget {
  const RegisterUserDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectivityChecker.checkConnection(displayAlert: true);
    Get.put(FirebasePatientDataAccess());
    final controller = Get.put(RegisterUserDataController());
    return WillPopScope(
      onWillPop: () async {
        logoutDialogue();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading:
              CustomBackButton(onPressed: () => logoutDialogue(), padding: 3),
          elevation: 0,
          scrolledUnderElevation: 5,
          backgroundColor: Colors.grey.shade100,
        ),
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: StretchingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'enterYourInfo'.tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20.0),
                    Obx(
                      () => RegularCard(
                        highlightRed: controller.highlightName.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHeader(
                                headerText: 'enterFullName'.tr, fontSize: 18),
                            TextFormFieldRegular(
                              labelText: 'fullName'.tr,
                              hintText: 'enterFullName'.tr,
                              prefixIconData: Icons.person,
                              textController: controller.nameTextController,
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
                        highlightRed: controller.highlightEmail.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHeader(
                                headerText: 'emailHintLabel'.tr, fontSize: 18),
                            TextFormFieldRegular(
                              labelText: 'emailLabel'.tr,
                              hintText: 'emailHintLabel'.tr,
                              prefixIconData: Icons.email,
                              textController: controller.emailTextController,
                              inputType: InputType.text,
                              editable: controller.makeEmailEditable,
                              textInputAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => RegularCard(
                        highlightRed: controller.highlightNationalId.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHeader(
                                headerText: 'enterNationalId'.tr, fontSize: 18),
                            TextFormFieldRegular(
                              labelText: 'nationalId'.tr,
                              hintText: 'enterNationalId'.tr,
                              prefixIconData: FontAwesomeIcons.idCard,
                              textController:
                                  controller.nationalIdTextController,
                              inputType: InputType.numbers,
                              editable: true,
                              textInputAction: TextInputAction.done,
                              inputFormatter:
                                  LengthLimitingTextInputFormatter(14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => RegularCard(
                        highlightRed: controller.highlightGender.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHeader(
                                headerText: 'enterGender'.tr, fontSize: 18),
                            CustomRadioButton(
                              key: controller.genderRadioKey,
                              buttonTextStyle: const ButtonTextStyle(
                                selectedColor: Colors.white,
                                unSelectedColor: Colors.black87,
                                textStyle: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              unSelectedColor: Theme.of(context).canvasColor,
                              buttonLables: ['male'.tr, 'female'.tr],
                              spacing: 10,
                              elevation: 0,
                              enableShape: true,
                              horizontal: false,
                              enableButtonWrap: false,
                              width: 110,
                              absoluteZeroSpacing: false,
                              padding: 15,
                              selectedColor: kDefaultColor,
                              buttonValues: const [
                                Gender.male,
                                Gender.female,
                              ],
                              radioButtonValue: (gender) {
                                controller.gender = gender;
                                controller.highlightGender.value = false;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => RegularCard(
                        highlightRed: controller.highlightBirthdate.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHeader(
                                headerText: 'enterBirthDate'.tr, fontSize: 18),
                            Container(
                              decoration: const BoxDecoration(
                                color: kDefaultColorLessShade,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              padding: const EdgeInsets.all(10.0),
                              child: SfDateRangePicker(
                                controller: controller.birthDateController,
                                onSelectionChanged: (args) =>
                                    controller.highlightBirthdate.value = false,
                                selectionMode:
                                    DateRangePickerSelectionMode.single,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => RegularCard(
                        highlightRed: controller.highlightProfilePic.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHeader(
                                headerText: 'enterPhoto'.tr, fontSize: 18),
                            controller.isProfileImageAdded.value
                                ? Center(
                                    child: CircleAvatar(
                                      radius: 80,
                                      backgroundImage: XFileImage(
                                          controller.profileImage.value!),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(height: 10.0),
                            RegularElevatedButton(
                              buttonText: controller.isProfileImageAdded.value
                                  ? 'changePhoto'.tr
                                  : 'addPhoto'.tr,
                              onPressed: () =>
                                  RegularBottomSheet.showRegularBottomSheet(
                                PhotoSelect(
                                  headerText: 'choosePicMethod'.tr,
                                  onCapturePhotoPress: () =>
                                      controller.captureProfilePic(),
                                  onChoosePhotoPress: () =>
                                      controller.pickProfilePic(),
                                ),
                              ),
                              enabled: true,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(
                      () => RegularCard(
                        highlightRed: controller.highlightNationalIdPick.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHeader(
                                headerText: 'enterNationalIDPhoto'.tr,
                                fontSize: 18),
                            controller.isNationalIDImageAdded.value
                                ? Center(
                                    child: Image(
                                      image:
                                          XFileImage(controller.iDImage.value!),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(height: 10.0),
                            RegularElevatedButton(
                              buttonText:
                                  controller.isNationalIDImageAdded.value
                                      ? 'changeNationalID'.tr
                                      : 'addNationalID'.tr,
                              onPressed: () =>
                                  RegularBottomSheet.showRegularBottomSheet(
                                PhotoSelect(
                                  headerText: 'chooseIDMethod'.tr,
                                  onCapturePhotoPress: () =>
                                      controller.captureIDPic(),
                                  onChoosePhotoPress: () =>
                                      controller.pickIdPic(),
                                ),
                              ),
                              enabled: true,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: RegularElevatedButton(
                        buttonText: 'continue'.tr,
                        onPressed: () => controller.checkPersonalInformation(),
                        enabled: true,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
