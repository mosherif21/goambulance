import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/components/requests_history/models.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../general/common_widgets/back_button.dart';
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
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
                                    image:
                                        NetworkImage(controller.mapUrl.value),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
