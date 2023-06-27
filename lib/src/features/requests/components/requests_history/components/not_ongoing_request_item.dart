import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';

import '../../../../../constants/enums.dart';
import '../models.dart';

class RequestItem extends StatelessWidget {
  const RequestItem({
    Key? key,
    required this.onPressed,
    required this.requestInfo,
  }) : super(key: key);
  final Function onPressed;
  final RequestDataModel requestInfo;
  @override
  Widget build(BuildContext context) {
    return Container(
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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: LineIcon.hospital(size: 40),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        requestInfo.hospitalName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 5),
                      AutoSizeText(
                        requestInfo.requestDateTime,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.black54,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          AutoSizeText(
                            '${'status'.tr}: ',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                            maxLines: 1,
                          ),
                          AutoSizeText(
                            requestInfo.requestStatus == RequestStatus.canceled
                                ? 'canceled'.tr
                                : 'completed'.tr,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: requestInfo.requestStatus ==
                                      RequestStatus.canceled
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
