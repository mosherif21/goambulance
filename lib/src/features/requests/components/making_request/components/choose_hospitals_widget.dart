import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../controllers/making_request_location_controller.dart';
import '../models.dart';
import 'hospital_choose_card.dart';
import 'loading_hospitals_choose.dart';

class ChooseHospitalsList extends StatelessWidget {
  const ChooseHospitalsList({Key? key, required this.controller})
      : super(key: key);
  final MakingRequestLocationController controller;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () => Future.sync(
        () {
          controller.clearSearchedHospitals();
          controller.pagingController.refresh();
        },
      ),
      child: PagedListView<int, HospitalModel>(
        pagingController: controller.pagingController,
        builderDelegate: PagedChildBuilderDelegate<HospitalModel>(
          itemBuilder: (context, hospitalItem, index) => HospitalChooseCard(
            hospitalItem: hospitalItem,
            controller: controller,
          ),
          firstPageProgressIndicatorBuilder: (context) {
            return const LoadingHospitalChoose();
          },
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
