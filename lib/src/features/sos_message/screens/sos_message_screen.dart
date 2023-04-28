import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/sos_message/controllers/sos_message_controller.dart';
import 'package:goambulance/src/general/common_widgets/back_button.dart';

import '../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../general/common_widgets/regular_card.dart';
import '../../../general/common_widgets/regular_elevated_button.dart';
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: AutoSizeText(
                                      'sosMessageHeader'.tr,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  TextFormFieldMultiline(
                                    labelText: 'sosMessage'.tr,
                                    hintText: 'enterSosMessage'.tr,
                                    textController:
                                        controller.sosMessageController,
                                    textInputAction: TextInputAction.done,
                                    inputFormatter:
                                        LengthLimitingTextInputFormatter(160),
                                    onSubmitted: () =>
                                        controller.saveSosMessage(),
                                  ),
                                  const SizedBox(height: 15),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: RegularElevatedButton(
                                      buttonText: 'save'.tr,
                                      onPressed: () =>
                                          controller.saveSosMessage(),
                                      enabled: true,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          RegularCard(
                            highlightRed: false,
                            child: Obx(
                              () => controller.contactsList.isNotEmpty
                                  ? SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          for (var contactItem
                                              in controller.contactsList)
                                            ContactItemWidget(
                                              contactItem: contactItem,
                                              onDeletePressed: () =>
                                                  controller.deleteContact(
                                                      contactItem: contactItem),
                                            )
                                        ],
                                      ),
                                    )
                                  : const NoEmergencyContacts(),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: RegularElevatedButton(
                              buttonText: 'addContact'.tr,
                              onPressed: () =>
                                  RegularBottomSheet.showRegularBottomSheet(
                                AddEmergencyContact(controller: controller),
                              ),
                              enabled: true,
                              color: Colors.black,
                            ),
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
