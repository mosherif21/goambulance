import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/enums.dart';

class OngoingRequestItem extends StatelessWidget {
  const OngoingRequestItem(
      {Key? key,
      required this.onPressed,
      required this.hospitalName,
      required this.dateTime,
      required this.status})
      : super(key: key);
  final Function onPressed;
  final String hospitalName;
  final String dateTime;
  final RequestStatus status;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: InkWell(
          hoverColor: Colors.grey.shade50,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          splashFactory: InkSparkle.splashFactory,
          onTap: () => onPressed(),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
                AutoSizeText(
                  hospitalName,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 5),
                AutoSizeText(
                  dateTime,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    AutoSizeText(
                      '${'status'.tr}: ',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                    ),
                    AutoSizeText(
                      status == RequestStatus.requestPending
                          ? 'pending'.tr
                          : status == RequestStatus.requestAccepted
                              ? 'accepted'.tr
                              : 'assigned'.tr,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: status == RequestStatus.requestPending
                              ? Colors.orange
                              : Colors.blue),
                      maxLines: 2,
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
