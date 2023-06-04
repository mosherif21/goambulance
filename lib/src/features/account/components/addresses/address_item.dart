import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import '../../controllers/addresses_controller.dart';
import '../models.dart';

class LoadAddressItem extends StatelessWidget {
  final controller = AddressesController.instance;

  LoadAddressItem({
    Key? key,
    required this.addressItem,
    required this.onDeletePressed,
    required this.isPrimary,
  }) : super(key: key);

  final AddressItem addressItem;
  final Function onDeletePressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
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
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 10.0),
                  AutoSizeText(
                    'Street'.tr + addressItem.streetName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                  ),
                  AutoSizeText(
                    'apartmentNumber'.tr + addressItem.apartmentNumber,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                  ),
                  AutoSizeText(
                    'floorNumber'.tr + addressItem.floorNumber,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                  ),
                  AutoSizeText(
                    'area'.tr + addressItem.areaName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      size: 40,
                      color: Colors.red,
                    ),
                    onPressed: () => onDeletePressed(),
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
                    buttonWidget: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                    ),
                    activeColor: Colors.blueAccent,
                    isFinished: false,
                    onWaitingProcess: () {
                      Future.delayed(const Duration(seconds: 1), () {
                        controller.updatePrimary(addressItem: addressItem);
                      });
                    },
                    onFinish: () {},
                  )
                : const AutoSizeText(
                    'Done',
                    style: TextStyle(
                      color: Colors.black,
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
