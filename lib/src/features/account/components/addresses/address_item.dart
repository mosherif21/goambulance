import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import '../../../../constants/colors.dart';
import '../../controllers/addresses_controller.dart';
import '../models.dart';

class LoadAddressItem extends StatelessWidget {
  final controller = AddressesController.instance;

  LoadAddressItem({
    Key? key,
    required this.addressItem,
    required this.onDeletePressed,
    required this.isPrimary,
    required this.onEditPressed,
  }) : super(key: key);

  final AddressItem addressItem;
  final Function onDeletePressed;
  final Function onEditPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: kDefaultColor, width: 2),
        color: Colors.white54,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    addressItem.locationName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      AutoSizeText(
                        'street'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                      ),
                      AutoSizeText(
                        addressItem.streetName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      AutoSizeText(
                        'apartmentNumber'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                      ),
                      AutoSizeText(
                        addressItem.apartmentNumber,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      AutoSizeText(
                        'floorNumber'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                      ),
                      AutoSizeText(
                        addressItem.floorNumber,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      AutoSizeText(
                        'area'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                      ),
                      AutoSizeText(
                        addressItem.areaName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle,
                      size: 35,
                      color: Colors.red,
                    ),
                    onPressed: () => onDeletePressed(),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      size: 35,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () => onEditPressed(),
                  ),
                ],
              )
            ],
          ),
          const Padding(padding: EdgeInsets.all(10)),
          Center(
            child: !isPrimary
                ? SwipeableButtonView(
                    buttonText: 'primaryAskText'.tr,
                    buttontextstyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    buttonWidget: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                    ),
                    activeColor: Colors.blueAccent,
                    isFinished: false,
                    onWaitingProcess: () =>
                        Future.delayed(const Duration(seconds: 1), () {
                      controller.updatePrimary(addressItem: addressItem);
                    }),
                    onFinish: () {},
                  )
                : AutoSizeText(
                    'primaryAddress'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kDefaultColor,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                  ),
          ),
        ],
      ),
    );
  }
}
