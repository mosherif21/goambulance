import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/general/common_widgets/rounded_elevated_button.dart';
import 'package:line_icons/line_icon.dart';

class SosRequestItem extends StatelessWidget {
  const SosRequestItem({
    Key? key,
    required this.onPressed,
  }) : super(key: key);
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.grey.shade300,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            padding: const EdgeInsets.all(5),
            child: const LineIcon.hospital(size: 40),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  'sosRequest'.tr,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 5),
                AutoSizeText(
                  'searchingHospitals'.tr,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.black54,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 90,
            height: 45,
            child: RoundedElevatedButton(
                buttonText: 'cancel'.tr,
                onPressed: onPressed,
                enabled: true,
                color: Colors.red),
          ),
        ],
      ),
    );
  }
}
