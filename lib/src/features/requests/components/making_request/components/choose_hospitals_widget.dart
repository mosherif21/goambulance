import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../controllers/making_request_location_controller.dart';
import '../models.dart';
import 'hospital_choose_card.dart';
import 'loading_hospitals_choose.dart';

class ChooseHospitalsList extends StatelessWidget {
  const ChooseHospitalsList(
      {Key? key, required this.makingRequestLocationController})
      : super(key: key);
  final MakingRequestLocationController makingRequestLocationController;
  @override
  Widget build(BuildContext context) {
    return StretchingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      child: SingleChildScrollView(
        child: Obx(
            () => makingRequestLocationController.searchedHospitals.isNotEmpty
                ? Column(
                    children: [
                      for (HospitalModel hospitalItem
                          in makingRequestLocationController.searchedHospitals)
                        HospitalChooseCard(
                          hospitalItem: hospitalItem,
                          controller: makingRequestLocationController,
                        ),
                    ],
                  )
                : const LoadingHospitalChoose()),
      ),
    );
  }
}
