import 'package:auto_size_text/auto_size_text.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/firebase_files/firebase_ambulance_employee_access.dart';

import '../../../../../connectivity/connectivity.dart';
import '../../../../../general/common_widgets/back_button.dart';
import '../../../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../../../general/common_widgets/regular_card.dart';
import '../../../../../general/common_widgets/regular_elevated_button.dart';
import '../../../../../general/common_widgets/text_header.dart';
import '../../../../../general/general_functions.dart';
import '../../../../account/components/new_account/photo_select.dart';
import '../../controllers/register_employee_data_controller.dart';

class RegisterEmployeeDataPage extends StatelessWidget {
  const RegisterEmployeeDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    ConnectivityChecker.checkConnection(displayAlert: true);
    Get.put(FirebaseAmbulanceEmployeeDataAccess());
    final controller = Get.put(RegisterEmployeeDataController());
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
                    AutoSizeText(
                      'employeeEnterYourInfo'.tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20.0),
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
                        buttonText: 'save'.tr,
                        onPressed: () => controller.checkPersonalInformation(),
                        enabled: true,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
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
