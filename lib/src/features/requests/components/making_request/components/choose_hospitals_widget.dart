import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/components/making_request/components/no_hospitals_found.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../general/general_functions.dart';
import '../../../controllers/making_request_location_controller.dart';
import 'hospital_choose_card.dart';
import 'loading_hospitals_choose.dart';

class ChooseHospitalsList extends StatelessWidget {
  const ChooseHospitalsList({Key? key, required this.controller})
      : super(key: key);
  final MakingRequestLocationController controller;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.hospitalsLoaded.value
          ? controller.searchedHospitals.isNotEmpty
              ? RefreshConfiguration(
                  headerTriggerDistance: 60,
                  maxOverScrollExtent: 60,
                  maxUnderScrollExtent: 0,
                  // enableScrollWhenRefreshCompleted: true,
                  enableLoadingWhenFailed: true,
                  hideFooterWhenNotFull: false,
                  enableRefreshVibrate: true,
                  enableLoadMoreVibrate: true,
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: ClassicHeader(
                      completeDuration: const Duration(milliseconds: 0),
                      releaseText: 'releaseToRefresh'.tr,
                      refreshingText: 'refreshing'.tr,
                      idleText: 'pullToRefresh'.tr,
                      completeText: 'refreshCompleted'.tr,
                      iconPos: isLangEnglish()
                          ? IconPosition.left
                          : IconPosition.right,
                    ),
                    controller: controller.hospitalsRefreshController,
                    onRefresh: () => controller.onRefresh(),
                    onLoading: () => controller.onLoadMore(),
                    footer: ClassicFooter(
                      completeDuration: const Duration(milliseconds: 0),
                      canLoadingText: 'releaseToLoad'.tr,
                      noDataText: 'noMoreHospitals'.tr,
                      idleText: 'pullToLoad'.tr,
                      loadingText: 'loading'.tr,
                      iconPos: isLangEnglish()
                          ? IconPosition.left
                          : IconPosition.right,
                    ),
                    child: ListView.builder(
                      itemBuilder: (context, index) => Obx(
                        () => HospitalChooseCard(
                          hospitalItem: controller.searchedHospitals[index],
                          selected: controller.searchedHospitals[index] ==
                              controller.selectedHospital.value,
                          onPress: () =>
                              controller.onHospitalChosen(hospitalIndex: index),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      shrinkWrap: true,
                      itemCount: controller.searchedHospitals.length,
                    ),
                  ),
                )
              : NoHospitalsFound(
                  onPressed: () => controller.onRefresh(),
                )
          : ListView.builder(
              itemBuilder: (context, _) => const LoadingHospitalCard(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: 3,
            ),
    );
  }
}
