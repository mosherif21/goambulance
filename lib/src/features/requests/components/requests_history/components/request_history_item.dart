import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';

class RequestHistoryItem extends StatelessWidget {
  const RequestHistoryItem({
    Key? key,
    required this.onPressed,
    required this.hospitalName,
    required this.dateTime,
    required this.status,
  }) : super(key: key);
  final Function onPressed;
  final String hospitalName;
  final String dateTime;
  final String status;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  padding: const EdgeInsets.all(10),
                  child: LineIcon.hospital(size: 40),
                ),
                const SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      hospitalName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 5),
                    AutoSizeText(
                      dateTime,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 5),
                    AutoSizeText(
                      '${'status'.tr}: $status',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                    ),
                  ],
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
