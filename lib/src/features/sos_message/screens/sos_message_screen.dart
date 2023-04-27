import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../general/common_widgets/back_button.dart';
import '../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../general/common_widgets/regular_card.dart';
import '../../../general/common_widgets/regular_elevated_button.dart';
import '../components/add_emergency_contact.dart';
import '../components/no_emergency_contacts.dart';
import '../controllers/emergency_contacts_controller.dart';

class SosMessageScreen extends StatelessWidget {
  const SosMessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmergencyContactsController());
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  RegularCard(
                    highlightRed: false,
                    child: SingleChildScrollView(
                      child: false
                          ? Column(
                              children: [],
                            )
                          : const NoEmergencyContacts(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
