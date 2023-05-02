import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../general/general_functions.dart';
import '../../../controllers/making_request_location_controller.dart';
import '../models.dart';
import 'hospital_choose_card.dart';
import 'loading_hospitals_choose.dart';
import 'no_hospitals_found.dart';

class ChooseHospitalsList extends StatelessWidget {
  const ChooseHospitalsList({Key? key, required this.controller})
      : super(key: key);
  final MakingRequestLocationController controller;
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      header: ClassicHeader(
        completeDuration: const Duration(milliseconds: 0),
        releaseText: 'releaseToRefresh'.tr,
        refreshingText: 'refreshing'.tr,
        idleText: 'pullToRefresh'.tr,
        completeText: 'refreshCompleted'.tr,
        iconPos: isLangEnglish() ? IconPosition.left : IconPosition.right,
      ),
      controller: controller.hospitalsRefreshController,
      onRefresh: () {
        controller.clearSearchedHospitals();
        controller.pagingController.refresh();
        controller.hospitalsRefreshController.refreshCompleted();
      },
      child: PagedListView<int, HospitalModel>(
        pagingController: controller.pagingController,
        builderDelegate: PagedChildBuilderDelegate<HospitalModel>(
          itemBuilder: (context, hospitalItem, index) => HospitalChooseCard(
            hospitalItem: hospitalItem,
            controller: controller,
          ),
          firstPageProgressIndicatorBuilder: (_) {
            return const LoadingHospitalChoose();
          },
          newPageProgressIndicatorBuilder: (_) {
            return const LoadingHospitalChoose();
          },
          noItemsFoundIndicatorBuilder: (_) {
            return const NoHospitalsFound();
          },
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
