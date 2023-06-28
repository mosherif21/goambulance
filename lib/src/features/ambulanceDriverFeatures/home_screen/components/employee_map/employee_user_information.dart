import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/account/components/models.dart';
import 'package:shimmer/shimmer.dart';

class EmployeeUserInformationWidget extends StatelessWidget {
  const EmployeeUserInformationWidget(
      {super.key, required this.userInformation, required this.profilePicUrl});
  final UserInformation userInformation;
  final String profilePicUrl;
  @override
  Widget build(BuildContext context) {
    return StretchingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Center(
                        child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: NetworkImage(profilePicUrl),
                    )),
                  ),
                  const SizedBox(height: 10),
                  AutoSizeText(
                    requestModel.hospitalName,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 5),
                  AutoSizeText(
                    requestModel.requestDateTime,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
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
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                        maxLines: 1,
                      ),
                      FramedText(
                        text:
                            requestModel.requestStatus == RequestStatus.canceled
                                ? 'canceled'.tr
                                : 'completed'.tr,
                        color:
                            requestModel.requestStatus == RequestStatus.canceled
                                ? Colors.red
                                : Colors.green,
                        fontSize: 15,
                      ),
                    ],
                  ),
                  if (requestModel.requestStatus == RequestStatus.canceled)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        AutoSizeText(
                          '${requestModel.cancelReason}'.tr,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Divider(
              thickness: 8,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: AutoSizeText(
                    'help'.tr,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
