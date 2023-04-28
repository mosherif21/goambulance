import 'package:auto_size_text/auto_size_text.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/colors.dart';
import 'package:goambulance/src/features/account/components/newAccount/photo_select.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';
import 'package:goambulance/src/general/common_widgets/regular_elevated_button.dart';
import 'package:goambulance/src/general/common_widgets/text_form_field.dart';
import 'package:goambulance/src/general/common_widgets/text_header.dart';

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
                          TextFormFieldRegular(
                            labelText: 'emailLabel'.tr,
                            hintText: 'emailHintLabel'.tr,
                            prefixIconData: Icons.email,
                            textController: controller.emailTextController,
                            inputType: InputType.text,
                            editable:
                                controller.makeEmailEditable ? true : false,
                            textInputAction: TextInputAction.next,
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
                          TextHeader(headerText: 'enterPhoto'.tr, fontSize: 18),
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
                            color: kDefaultColor,
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
                            buttonText: controller.isNationalIDImageAdded.value
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
                            color: kDefaultColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: RegularElevatedButton(
                      buttonText: 'continue'.tr,
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
