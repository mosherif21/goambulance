import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/sos_message/controllers/sos_message_controller.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';

import '../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../general/common_widgets/regular_card.dart';
import '../../../general/common_widgets/rounded_elevated_button.dart';
import '../../../general/common_widgets/text_form_field_multiline.dart';
import '../components/add_emergency_contact.dart';
import '../components/contact_item.dart';
import '../components/loading_contacts_info.dart';
import '../components/no_emergency_contacts.dart';

class SosMessageScreen extends StatelessWidget {
  const SosMessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SosMessageController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'sosMessage'.tr,
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
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              child: Obx(
                () => controller.sosMessageDataLoaded.value
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Obx(
                            () => RegularCard(
                              highlightRed:
                                  controller.highlightSosMessage.value,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      'sosMessageHeader'.tr,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormFieldMultiline(
                                      labelText: 'sosMessage'.tr,
                                      hintText: 'enterSosMessage'.tr,
                                      textController:
                                          controller.sosMessageController,
                                      textInputAction: TextInputAction.done,
                                      inputFormatter:
                                          LengthLimitingTextInputFormatter(160),
                                      onSubmitted: () =>
                                          controller.onSaveSosMessageClick(),
                                    ),
                                    const SizedBox(height: 15),
                                    Obx(
                                      () => RoundedElevatedButton(
                                        buttonText: 'save'.tr,
                                        onPressed: () =>
                                            controller.onSaveSosMessageClick(),
                                        enabled:
                                            controller.enableSaveButton.value,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          RegularCard(
                            highlightRed: false,
                            child: Obx(
                              () => controller.contactsList.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: AutoSizeText(
                                            'savedEmergencyContacts'.tr,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        for (var contactItem
                                            in controller.contactsList)
                                          ContactItemWidget(
                                            contactItem: contactItem,
                                            onDeletePressed: () =>
                                                controller.deleteContact(
                                                    contactItem: contactItem),
                                          ),
                                        const SizedBox(height: 10),
                                        RoundedElevatedButton(
                                          buttonText: 'addContact'.tr,
                                          onPressed: () => RegularBottomSheet
                                              .showRegularBottomSheet(
                                            const AddEmergencyContact(),
                                          ),
                                          enabled: true,
                                          color: Colors.black,
                                        ),
                                      ],
                                    )
                                  : const NoEmergencyContacts(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          RoundedElevatedButton(
                            buttonText: 'sendSosMessage'.tr,
                            onPressed: () => controller.sendSosMessage(),
                            enabled: true,
                            color: Colors.red,
                          ),
                        ],
                      )
                    : const LoadingContacts(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
