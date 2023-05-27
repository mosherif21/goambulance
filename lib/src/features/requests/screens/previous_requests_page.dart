import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../constants/enums.dart';
import '../../../general/general_functions.dart';
import '../components/requests_history/components/loading_requests_history.dart';
import '../components/requests_history/components/no_requests_history.dart';
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
            child: Obx(
              () => controller.requestLoaded.value
                  ? controller.requestsList.isNotEmpty
                      ? RefreshConfiguration(
                          headerTriggerDistance: 60,
                          maxOverScrollExtent: 20,
                          maxUnderScrollExtent: 20,
                          // footerTriggerDistance: 500,
                          // enableScrollWhenRefreshCompleted: true,
                          enableLoadingWhenFailed: true,
                          hideFooterWhenNotFull: true,
                          enableRefreshVibrate: true,
                          //enableLoadMoreVibrate: true,
                          child: SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: false,
                            header: ClassicHeader(
                              completeDuration: const Duration(milliseconds: 0),
                              releaseText: 'releaseToRefresh'.tr,
                              refreshingText: 'refreshing'.tr,
                              idleText: 'pullToRefresh'.tr,
                              completeText: 'refreshCompleted'.tr,
                              iconPos: isLangEnglish()
                                  ? IconPosition.left
                                  : IconPosition.right,
                              textStyle: const TextStyle(color: Colors.black),
                              failedIcon:
                                  const Icon(Icons.error, color: Colors.black),
                              completeIcon:
                                  const Icon(Icons.done, color: Colors.black),
                              idleIcon: const Icon(Icons.arrow_downward,
                                  color: Colors.black),
                              releaseIcon: const Icon(Icons.refresh,
                                  color: Colors.black),
                            ),
                            controller: controller.requestsRefreshController,
                            onRefresh: () => controller.onRefresh(),
                            //onLoading: () => controller.onLoadMore(),
                            // footer: ClassicFooter(
                            //   completeDuration: const Duration(milliseconds: 0),
                            //   canLoadingText: 'releaseToLoad'.tr,
                            //   noDataText: 'noMoreHospitals'.tr,
                            //   idleText: 'pullToLoad'.tr,
                            //   loadingText: 'loading'.tr,
                            //   iconPos: isLangEnglish()
                            //       ? IconPosition.left
                            //       : IconPosition.right,
                            // ),
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                final requestStatus =
                                    index != controller.requestsList.length
                                        ? controller
                                            .requestsList[index].requestStatus
                                        : RequestStatus.notRequested;
                                final ongoingRequest = requestStatus ==
                                        RequestStatus.requestPending ||
                                    requestStatus ==
                                        RequestStatus.requestAccepted ||
                                    requestStatus ==
                                        RequestStatus.requestAssigned;
                                return index != controller.requestsList.length
                                    ? ongoingRequest
                                        ? OngoingRequestItem(
                                            onPressed: () {},
                                            requestInfo:
                                                controller.requestsList[index],
                                          )
                                        : RequestItem(
                                            onPressed: () {},
                                            requestInfo:
                                                controller.requestsList[index],
                                          )
                                    : SizedBox(height: screenHeight * 0.08);
                              },
                              itemCount: controller.requestsList.length + 1,
                              shrinkWrap: true,
                            ),
                          ),
                        )
                      : const EmptyRequestsHistory()
                  : const LoadingRequestsHistory(),
            ),
          ),
        ),
      ),
    );
  }
}
