import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/controllers/sos_settings_controller.dart';

import '../../../../general/common_widgets/back_button.dart';
import '../../../../general/common_widgets/custom_rolling_switch.dart';
import '../../../../general/common_widgets/regular_card.dart';
import '../../../../general/common_widgets/text_header.dart';

class SOSRequestSettings extends StatelessWidget {
  const SOSRequestSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SosSettingsController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'sosRequestSettings'.tr,
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
                  RegularCard(
                    highlightRed: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHeader(
                          headerText: 'shakeToSos'.tr,
                          fontSize: 18,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Spacer(),
                            CustomRollingSwitch(
                              onText: 'yes'.tr,
                              offText: 'no'.tr,
                              onIcon: Icons.check,
                              offIcon: Icons.close,
                              onSwitched: (bool state) =>
                                  controller.setShakeToSos(state),
                              keyInternal: controller.shakePrimaryKey,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  RegularCard(
                    highlightRed: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHeader(
                          headerText: 'voiceToSos'.tr,
                          fontSize: 18,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Spacer(),
                            CustomRollingSwitch(
                              onText: 'yes'.tr,
                              offText: 'no'.tr,
                              onIcon: Icons.check,
                              offIcon: Icons.close,
                              onSwitched: (bool state) =>
                                  controller.setVoiceToSos(state),
                              keyInternal: controller.voicePrimaryKey,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  RegularCard(
                    highlightRed: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHeader(
                          headerText: 'sendSosSms'.tr,
                          fontSize: 18,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Spacer(),
                            CustomRollingSwitch(
                              onText: 'yes'.tr,
                              offText: 'no'.tr,
                              onIcon: Icons.check,
                              offIcon: Icons.close,
                              onSwitched: (bool state) =>
                                  controller.setSMSToSos(state),
                              keyInternal: controller.smsPrimaryKey,
                            ),
                          ],
                        )
                      ],
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
