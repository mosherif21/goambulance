import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/app_init.dart';
import 'package:goambulance/src/general/general_functions.dart';

import '../../../constants/enums.dart';
import '../../../general/common_widgets/back_button.dart';
import '../../../general/common_widgets/regular_clickable_card.dart';
import '../controllers/first_aid_assets.dart';

class EmergencyNumbersScreen extends StatelessWidget {
  const EmergencyNumbersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'emergencyNumbers'.tr,
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
          padding: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int emergencyNumber) {
                return RegularClickableCard(
                  onPressed: () async {
                    if (!AppInit.isWeb) {
                      if (await handleCallPermission()) {
                        await FlutterPhoneDirectCaller.callNumber(
                            emergencyNumbers[emergencyNumber]);
                      }
                    } else {
                      showSnackBar(
                          text: 'useMobileToThisFeature'.tr,
                          snackBarType: SnackBarType.info);
                    }
                  },
                  title: 'emergencyNumber${emergencyNumber + 1}'.tr,
                  subTitle: emergencyNumbers[emergencyNumber],
                  icon: Icons.call,
                  iconColor: Colors.green,
                  imgPath: getEmergencyNumberImage(emergencyNumber + 1),
                );
              },
              itemCount: emergencyNumbers.length,
            ),
          ),
        ),
      ),
    );
  }
}
