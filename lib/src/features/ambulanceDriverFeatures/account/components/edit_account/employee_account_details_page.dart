import 'package:auto_size_text/auto_size_text.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/colors.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';
import 'package:goambulance/src/general/common_widgets/regular_elevated_button.dart';
import 'package:goambulance/src/general/common_widgets/rounded_elevated_button.dart';
import 'package:goambulance/src/general/common_widgets/text_form_field.dart';
import 'package:goambulance/src/general/common_widgets/text_header.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../connectivity/connectivity.dart';
import '../../../../../constants/enums.dart';
import '../../../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../../../general/common_widgets/regular_card.dart';
import '../../../../account/components/new_account/photo_select.dart';
import '../../controllers/employee_account_details_controller.dart';

class EmployeeEditUserDataPage extends StatelessWidget {
  const EmployeeEditUserDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectivityChecker.checkConnection(displayAlert: true);
    final controller = Get.put(EmployeeUserDataController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'EmployeeAccountTitle1'.tr,
          maxLines: 1,
        ),
        titleTextStyle: const TextStyle(
            fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
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
                  const SizedBox(height: 10.0),
                  RegularCard(
                    highlightRed: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHeader(
                          headerText: 'fullName'.tr,
                          fontSize: 18,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 5),
                        TextFormFieldRegular(
                          labelText: 'fullName'.tr,
                          hintText: 'enterFullName'.tr,
                          prefixIconData: Icons.person,
                          textController: controller.nameTextController,
                          inputType: InputType.text,
                          editable: false,
                          textInputAction: TextInputAction.next,
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
                            headerText: 'emailLabel'.tr,
                            fontSize: 18,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormFieldRegular(
                                  labelText: 'emailLabel'.tr,
                                  hintText: 'emailHintLabel'.tr,
                                  prefixIconData: Icons.email,
                                  textController:
                                      controller.emailTextController,
                                  inputType: InputType.text,
                                  editable: false,
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      controller.authRep.isEmailVerified.value
                                          ? Colors.green
                                          : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Icon(
                                    controller.authRep.isEmailVerified.value
                                        ? Icons.check
                                        : Icons.close_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          !controller.authRep.isEmailVerified.value
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: RoundedElevatedButton(
                                    buttonText:
                                        controller.verificationSent.value
                                            ? 'verificationSent'.tr
                                            : 'verify'.tr,
                                    onPressed: controller.verifyEmail,
                                    enabled: !controller.verificationSent.value,
                                    color: kDefaultColor,
                                  ),
                                )
                              : const SizedBox.shrink(),
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
                          headerText: 'nationalId'.tr,
                          fontSize: 18,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 5),
                        TextFormFieldRegular(
                          labelText: 'nationalId'.tr,
                          hintText: 'enterNationalId'.tr,
                          prefixIconData: FontAwesomeIcons.idCard,
                          textController: controller.nationalIdTextController,
                          inputType: InputType.numbers,
                          editable: false,
                          textInputAction: TextInputAction.done,
                          inputFormatter: LengthLimitingTextInputFormatter(14),
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
                          headerText: 'enterPhoto'.tr,
                          fontSize: 18,
                          maxLines: 1,
                        ),
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
                            fontSize: 18,
                            maxLines: 1,
                          ),
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
                      onPressed: () => controller.updateUserInfoData(),
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
