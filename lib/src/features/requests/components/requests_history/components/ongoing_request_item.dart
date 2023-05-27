import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/enums.dart';
import '../models.dart';

class OngoingRequestItem extends StatelessWidget {
  const OngoingRequestItem({
    Key? key,
    required this.onPressed,
    required this.requestInfo,
  }) : super(key: key);
  final Function onPressed;
  final RequestHistoryModel requestInfo;

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: SizedBox(
                    width: 350,
                    height: 200,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        image: DecorationImage(
                          image: NetworkImage(requestInfo.mapUrl!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          requestInfo.hospitalName,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 5),
                        AutoSizeText(
                          requestInfo.requestDateTime,
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
                              requestInfo.requestStatus ==
                                      RequestStatus.requestPending
                                  ? 'pending'.tr
                                  : requestInfo.requestStatus ==
                                          RequestStatus.requestAccepted
                                      ? 'accepted'.tr
                                      : 'assigned'.tr,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: requestInfo.requestStatus ==
                                          RequestStatus.requestPending
                                      ? Colors.orange
                                      : Colors.blue),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
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
