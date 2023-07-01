import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../constants/enums.dart';
import '../../../general/common_widgets/regular_elevated_button.dart';
import '../../../general/common_widgets/text_form_field.dart';
import '../controllers/sos_message_controller.dart';

class AddEmergencyContact extends StatelessWidget {
  const AddEmergencyContact({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = SosMessageController.instance;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'contactInfo'.tr,
            style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Colors.black87),
            maxLines: 2,
          ),
          const SizedBox(height: 10.0),
          TextFormFieldRegular(
            labelText: 'contactName'.tr,
            hintText: 'enterContactName'.tr,
            prefixIconData: Icons.contacts,
            textController: controller.contactNameTextController,
            inputType: InputType.text,
            editable: true,
            textInputAction: TextInputAction.done,
            inputFormatter: LengthLimitingTextInputFormatter(50),
          ),
          const SizedBox(height: 10),
          IntlPhoneField(
            decoration: InputDecoration(
              labelText: 'contactNumber'.tr,
              hintText: 'enterContactNumber'.tr,
              border: const OutlineInputBorder(
                borderSide: BorderSide(),
              ),
            ),
            initialCountryCode: 'EG',
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
            onChanged: controller.onPhoneNumberChanged,
          ),
          const SizedBox(height: 10.0),
          Obx(
            () => RegularElevatedButton(
              buttonText: 'add'.tr,
              onPressed: () => controller.addContact(),
              enabled: controller.contactName.value.isNotEmpty &&
                      controller.phoneNumber.value.isNotEmpty
                  ? true
                  : false,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
