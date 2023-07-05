import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../general/common_widgets/back_button.dart';
import '../../../../general/common_widgets/regular_clickable_card_icon.dart';
import '../../../../general/general_functions.dart';
import '../models.dart';

class AmbulanceInformationPage extends StatelessWidget {
  const AmbulanceInformationPage({
    super.key,
    required this.ambulanceInfo,
  });

  final AmbulanceInformationDataModel ambulanceInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const RegularBackButton(padding: 0),
        title: AutoSizeText(
          'ambulanceInformation'.tr,
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
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          bottom: 15, left: 10, right: 10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: kDefaultColor, width: 2),
                        color: Colors.white54,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ambulanceDriver'.tr,
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'name'.tr,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  child: AutoSizeText(
                                    ambulanceInfo.ambulanceDriverName,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: kDefaultColor, width: 1),
                                    color: Colors.white54,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: RegularClickableCardIcon(
                                    onPressed: () => callNumber(
                                        phoneNumber:
                                            ambulanceInfo.ambulanceDriverPhone),
                                    title: 'phoneNumber'.tr,
                                    subTitle:
                                        ambulanceInfo.ambulanceDriverPhone,
                                    leadingIcon: Icons.phone_android,
                                    trailingIcon: Icons.phone,
                                    trailingIconColor: Colors.blue,
                                    leadingIconColor: Colors.black,
                                    borderRadius: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          bottom: 15, left: 10, right: 10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: kDefaultColor, width: 2),
                        color: Colors.white54,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ambulanceMedic'.tr,
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'name'.tr,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  child: AutoSizeText(
                                    ambulanceInfo.ambulanceMedicName,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: kDefaultColor, width: 1),
                                    color: Colors.white54,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: RegularClickableCardIcon(
                                    onPressed: () => callNumber(
                                        phoneNumber:
                                            ambulanceInfo.ambulanceMedicPhone),
                                    title: 'phoneNumber'.tr,
                                    subTitle: ambulanceInfo.ambulanceMedicPhone,
                                    leadingIcon: Icons.phone_android,
                                    trailingIcon: Icons.phone,
                                    trailingIconColor: Colors.blue,
                                    leadingIconColor: Colors.black,
                                    borderRadius: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          bottom: 15, left: 10, right: 10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: kDefaultColor, width: 2),
                        color: Colors.white54,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ambulanceDetails'.tr,
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'type'.tr,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  child: AutoSizeText(
                                    ambulanceInfo.ambulanceType,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'licencePlate'.tr,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Flexible(
                                  child: AutoSizeText(
                                    ambulanceInfo.licensePlate,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
