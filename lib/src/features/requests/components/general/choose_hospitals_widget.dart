import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/requests/components/general/no_hospitals_found.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../general/general_functions.dart';
import 'hospital_choose_card.dart';
import 'loading_hospitals_choose.dart';

class ChooseHospitalsList extends StatelessWidget {
  const ChooseHospitalsList({Key? key, required this.controller})
      : super(key: key);
  final dynamic controller;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.hospitalsLoaded.value
          ? RefreshConfiguration(
              headerTriggerDistance: 60,
              maxOverScrollExtent: 20,
              maxUnderScrollExtent: 20,
              // footerTriggerDistance: 500,
              // enableScrollWhenRefreshCompleted: true,
              enableLoadingWhenFailed: true,
              hideFooterWhenNotFull: true,
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
                  iconPos:
                      isLangEnglish() ? IconPosition.left : IconPosition.right,
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
                  iconPos:
                      isLangEnglish() ? IconPosition.left : IconPosition.right,
                ),
                child: ListView.builder(
                  itemBuilder: (context, index) => controller
                          .searchedHospitals.isNotEmpty
                      ? Obx(
                          () => Container(
                            margin: EdgeInsets.only(top: index == 0 ? 8 : 0),
                            child: HospitalChooseCard(
                              hospitalItem: controller.searchedHospitals[index],
                              selected: controller.searchedHospitals[index] ==
                                  controller.selectedHospital.value,
                              onPress: () => controller.onHospitalChosen(
                                  hospitalIndex: index),
                            ),
                          ),
                        )
                      : const NoHospitalsFound(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: controller.searchedHospitals.isNotEmpty
                      ? controller.searchedHospitals.length
                      : 1,
                ),
              ),
            )
          : ListView.builder(
              itemBuilder: (context, _) => const LoadingHospitalCard(),
              padding: EdgeInsets.zero,
              itemCount: 3,
            ),
    );
  }
}
