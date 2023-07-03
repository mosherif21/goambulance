import 'package:auto_size_text/auto_size_text.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
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
import 'package:goambulance/src/general/validation_functions.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../connectivity/connectivity.dart';
import '../../../../constants/enums.dart';
import '../../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../../general/common_widgets/regular_card.dart';
import '../../controllers/edit_user_data_controller.dart';
import '../new_account/photo_select.dart';

class EditUserDataPage extends StatelessWidget {
  const EditUserDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectivityChecker.checkConnection(displayAlert: true);
    final controller = Get.put(EditUserDataController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'accountTitle1'.tr,
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
          child: Form(
            key: controller.formKey,
            child: StretchingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    Obx(
                      () => RegularCard(
                        highlightRed: controller.highlightName.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHeader(
                              headerText: 'enterFullName'.tr,
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
                              editable: true,
                              textInputAction: TextInputAction.next,
                              validationFunction: validateTextOnly,
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
                              headerText: 'emailHintLabel'.tr,
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
                                Obx(() => Container(
                                      decoration: BoxDecoration(
                                        color: controller
                                                .authRep.isEmailVerified.value
                                            ? Colors.green
                                            : Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Icon(
                                          controller
                                                  .authRep.isEmailVerified.value
                                              ? Icons.check
                                              : Icons.close_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Obx(() => !controller.authRep.isEmailVerified.value
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: RoundedElevatedButton(
                                      buttonText:
                                          controller.verificationSent.value
                                              ? 'verificationSent'.tr
                                              : 'verify'.tr,
                                      onPressed: controller.verifyEmail,
                                      enabled:
                                          !controller.verificationSent.value,
                                      color: kDefaultColor,
                                    ),
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
                              headerText: 'enterNationalId'.tr,
                              fontSize: 18,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 5),
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
                              validationFunction: validateNationalId,
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
                            headerText: 'enterGender'.tr,
                            fontSize: 18,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5),
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
                            headerText: 'enterBirthDate'.tr,
                            fontSize: 18,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: const BoxDecoration(
                              color: kDefaultColorLessShade,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: SfDateRangePicker(
                              controller: controller.birthDateController,
                              selectionMode:
                                  DateRangePickerSelectionMode.single,
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
                                          : controller
                                              .profileMemoryImage.value!,
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
                                          ? XFileImage(
                                              controller.iDImage.value!)
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
                                enabled:
                                    controller.isNationalIDImageLoaded.value,
                                color: kDefaultColor,
                              ),
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
                            headerText: 'enterBackupPhoneNo'.tr,
                            fontSize: 18,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5.0),
                          IntlPhoneField(
                            initialValue: controller
                                    .userInfo.backupNumber.isNotEmpty
                                ? controller.userInfo.backupNumber.substring(3)
                                : '',
                            decoration: InputDecoration(
                              labelText: 'phoneLabel'.tr,
                              hintText: 'phoneFieldLabel'.tr,
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            initialCountryCode: 'EG',
                            invalidNumberMessage: 'invalidNumberMsg'.tr,
                            countries: const [
                              Country(
                                name: "Egypt",
                                nameTranslations: {
                                  "sk": "Egypt",
                                  "se": "Egypt",
                                  "pl": "Egipt",
                                  "no": "Egypt",
                                  "ja": "エジプト",
                                  "it": "Egitto",
                                  "zh": "埃及",
                                  "nl": "Egypt",
                                  "de": "Ägypt",
                                  "fr": "Égypte",
                                  "es": "Egipt",
                                  "en": "Egypt",
                                  "pt_BR": "Egito",
                                  "sr-Cyrl": "Египат",
                                  "sr-Latn": "Egipat",
                                  "zh_TW": "埃及",
                                  "tr": "Mısır",
                                  "ro": "Egipt",
                                  "ar": "مصر",
                                  "fa": "مصر",
                                  "yue": "埃及"
                                },
                                flag: "🇪🇬",
                                code: "EG",
                                dialCode: "20",
                                minLength: 10,
                                maxLength: 10,
                              ),
                            ],
                            pickerDialogStyle: PickerDialogStyle(
                              searchFieldInputDecoration:
                                  InputDecoration(hintText: 'searchCountry'.tr),
                            ),
                            onChanged: (phone) =>
                                controller.backupPhoneNo = phone.completeNumber,
                          ),
                        ],
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
