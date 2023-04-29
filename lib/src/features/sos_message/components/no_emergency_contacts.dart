import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/assets_strings.dart';
import '../../../general/common_widgets/regular_bottom_sheet.dart';
import '../../../general/common_widgets/rounded_elevated_button.dart';
import '../../../general/general_functions.dart';
import 'add_emergency_contact.dart';

class NoEmergencyContacts extends StatelessWidget {
  const NoEmergencyContacts({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kNoEmergencyContact,
              height: screenHeight * 0.2,
            ),
            const SizedBox(height: 10),
            AutoSizeText(
              'noEmergencyContacts'.tr,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            RoundedElevatedButton(
              buttonText: 'addContact'.tr,
              onPressed: () => RegularBottomSheet.showRegularBottomSheet(
                const AddEmergencyContact(),
              ),
              enabled: true,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
