import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/constants/enums.dart';

import '../../../general/general_functions.dart';
import '../components/requests_history/components/not_ongoing_request_item.dart';
import '../components/requests_history/components/ongoing_request_item.dart';
import '../controllers/requests_history_controller.dart';

class PreviousRequestsPage extends StatelessWidget {
  const PreviousRequestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final controller = Get.put(RequestsHistoryController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AutoSizeText(
          'recentRequests'.tr,
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
          padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
          child: StretchingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return index == 0
                            ? Obx(
                                () => controller.snapshotLoaded.value
                                    ? OngoingRequestItem(
                                        onPressed: () {},
                                        hospitalName: 'Royal Hospital',
                                        dateTime: 'Apr 17 2023 1:54 PM',
                                        status: RequestStatus.requestAccepted,
                                        mapUrl: controller.mapUrl,
                                      )
                                    : const SizedBox.shrink(),
                              )
                            : index > 0 && index < 9
                                ? RequestItem(
                                    onPressed: () {},
                                    hospitalName: 'Royal Hospital',
                                    dateTime: 'Apr 17 2023 1:54 PM',
                                    status: RequestStatus.requestCanceled,
                                  )
                                : SizedBox(height: screenHeight * 0.07);
                      },
                      itemCount: 10,
                      shrinkWrap: true,
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
