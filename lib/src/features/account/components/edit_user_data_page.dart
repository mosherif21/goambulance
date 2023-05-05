import 'package:auto_size_text/auto_size_text.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/authentication_repository.dart';
import 'package:goambulance/src/constants/colors.dart';
import 'package:goambulance/src/features/account/components/newAccount/photo_select.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';
import 'package:goambulance/src/general/common_widgets/regular_elevated_button.dart';
import 'package:goambulance/src/general/common_widgets/text_form_field.dart';
import 'package:goambulance/src/general/common_widgets/text_header.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../connectivity/connectivity.dart';
import '../../../constants/enums.dart';
import '../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../general/common_widgets/regular_card.dart';
import '../controllers/edit_user_data_controller.dart';

class EditUserDataPage extends StatelessWidget {
  const EditUserDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectivityChecker.checkConnection(displayAlert: true);
    final controller = Get.put(EditUserDataController());
    //leh ht3mlo controller m5sos mat3ml el timer fe EditUserDataController 3ady
    final CountdownController timerController = Get.put(CountdownController());

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
                          Text(controller.emailTextController.text)
                          // TextFormFieldRegular(
                          //   labelText: 'emailLabel'.tr,
                          //   hintText: 'emailHintLabel'.tr,
                          //   prefixIconData: Icons.email,
                          //   textController: controller.emailTextController,
                          //   inputType: InputType.text,
                          //   editable: controller.makeEmailEditable,
                          //   textInputAction: TextInputAction.next,
                          // )
                          ,
                          Obx(() => AuthenticationRepository
                                  .instance.isEmailVerified.value
                              ? Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: RegularElevatedButton(
                                    buttonText: 'verify'.tr,
                                    onPressed: () {
                                      controller.makeButtonEditable = false;
                                      timerController.restart();
                                      if (kDebugMode) {
                                        print("Timer Started ..............");
                                      }
                                      // controller.currentUser
                                      //     .sendEmailVerification();
                                    },
                                    enabled: controller.makeButtonEditable,
                                    color: kDefaultColor,
                                  ),
                                )
                              : const SizedBox.shrink()),
                          Obx(() => AuthenticationRepository
                                  .instance.isEmailVerified.value
                              ? Countdown(
                                  controller: timerController,
                                  seconds: 10,
                                  build: (BuildContext context, double time) =>
                                      Text(time.toString()),
                                  interval: const Duration(milliseconds: 100),
                                  onFinished: () {
                                    if (kDebugMode) {
                                      print("Timer Finished ..............");
                                    }

                                    controller.makeButtonEditable = true;
                                    timerController.pause();
                                  },
                                )
                              : const SizedBox.shrink()),
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
                            textController: controller.nationalIdTextController,
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
                  RegularCard(
                    highlightRed: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHeader(headerText: 'enterGender'.tr, fontSize: 18),
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
                          },
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
                            selectionMode: DateRangePickerSelectionMode.single,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RegularCard(
                    highlightRed: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHeader(headerText: 'enterPhoto'.tr, fontSize: 18),
                        Obx(
                          () => controller.isProfileImageLoaded.value
                              ? Center(
                                  child: CircleAvatar(
                                    radius: 80,
                                    backgroundImage: controller
                                            .isProfileImageChanged.value
                                        ? XFileImage(
                                            controller.profileImage.value!)
                                        : controller.profileMemoryImage.value!,
                                  ),
                                )
                              : Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: const Center(
                                    child: CircleAvatar(
                                      radius: 80,
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10.0),
                        Obx(
                          () => RegularElevatedButton(
                            buttonText: 'changePhoto'.tr,
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
                            enabled: controller.isProfileImageLoaded.value,
                            color: kDefaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => RegularCard(
                      highlightRed: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextHeader(
                              headerText: 'enterNationalIDPhoto'.tr,
                              fontSize: 18),
                          controller.isNationalIDImageLoaded.value
                              ? Center(
                                  child: Image(
                                    image: controller
                                            .isNationalIDImageChanged.value
                                        ? XFileImage(controller.iDImage.value!)
                                        : controller.idMemoryImage.value!,
                                  ),
                                )
                              : Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Center(
                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 10.0),
                          Obx(
                            () => RegularElevatedButton(
                              buttonText: 'changeNationalID'.tr,
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
                              enabled: controller.isNationalIDImageLoaded.value,
                              color: kDefaultColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: RegularElevatedButton(
                      buttonText: 'save'.tr,
                      onPressed: () async =>
                          await controller.checkPersonalInformation(),
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
