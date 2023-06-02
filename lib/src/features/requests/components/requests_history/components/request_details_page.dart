import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/components/requests_history/models.dart';
import 'package:goambulance/src/general/common_widgets/framed_text.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../constants/enums.dart';
import '../../../../../general/common_widgets/back_button.dart';
import '../../../../../general/common_widgets/no_frame_clickable_card.dart';
import '../../../controllers/request_history_details_controller.dart';

class RequestDetailsPage extends StatelessWidget {
  const RequestDetailsPage({Key? key, required this.requestModel})
      : super(key: key);
  final RequestHistoryModel requestModel;
  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(RequestsHistoryDetailsController(requestModel: requestModel));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'requestDetails'.tr,
          maxLines: 1,
        ),
        titleTextStyle: const TextStyle(
            fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StretchingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Obx(
                          () => controller.mapUrl.value.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: SizedBox(
                                    width: 350,
                                    height: 200,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              controller.mapUrl.value),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    width: 350,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      AutoSizeText(
                        requestModel.hospitalName,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 5),
                      AutoSizeText(
                        requestModel.requestDateTime,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          AutoSizeText(
                            '${'status'.tr}: ',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                            maxLines: 1,
                          ),
                          FramedText(
                            text: requestModel.requestStatus ==
                                    RequestStatus.canceled
                                ? 'canceled'.tr
                                : 'completed'.tr,
                            color: requestModel.requestStatus ==
                                    RequestStatus.canceled
                                ? Colors.red
                                : Colors.green,
                            fontSize: 15,
                          ),
                        ],
                      ),
                      if (requestModel.requestStatus == RequestStatus.canceled)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            AutoSizeText(
                              '${requestModel.cancelReason}'.tr,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Divider(
                  thickness: 8,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: AutoSizeText(
                        'help'.tr,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    NoFrameClickableCard(
                      onPressed: () {},
                      title: 'problemRequest'.tr,
                      subTitle: 'reportRequest'.tr,
                      leadingIcon: Icons.report,
                      leadingIconColor: Colors.black,
                      trailingIcon: Icons.arrow_forward_ios_outlined,
                      trailingIconColor: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
