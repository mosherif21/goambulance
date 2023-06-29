import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../general/general_functions.dart';
import '../../account/components/models.dart';

class NotiItem extends StatelessWidget {
  const NotiItem({
    Key? key,
    required this.notificationItem,
  }) : super(key: key);

  final NotificationItem notificationItem;

  @override
  Widget build(BuildContext context) {
    final screenWidth = getScreenWidth(context);

    DateTime dateTime = notificationItem.timestamp.toDate();
    String formattedDateTime =
    DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey, width: 2),
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            notificationItem.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 10.0),
          AutoSizeText(
            notificationItem.body,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 5,
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            width: screenWidth,
            child: AutoSizeText(
              formattedDateTime,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              maxLines: 6,
            ),
          ),
        ],
      ),
    );
  }
}
