import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../general/common_widgets/back_button.dart';
import '../../../../general/common_widgets/regular_elevated_button.dart';
import '../../controllers/making_request_information_controller.dart';

class NormalRequestScreen extends StatelessWidget {
  const NormalRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final makingRequestInformationController =
        Get.put(MakingRequestInformationController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'normalRequest'.tr,
          maxLines: 1,
        ),
        titleTextStyle: const TextStyle(
            fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
        elevation: 0,
        scrolledUnderElevation: 5,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RegularElevatedButton(
                    buttonText: 'continue'.tr,
                    onPressed: () async =>
                        await makingRequestInformationController
                            .confirmRequestInformation(),
                    enabled: true,
                    color: Colors.black,
                    fontSize: 20,
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
