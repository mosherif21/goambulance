import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goambulance/src/features/sos_message/controllers/sos_message_controller.dart';
import 'package:line_icons/line_icon.dart';

import '../../../general/general_functions.dart';

class ContactItemWidget extends StatelessWidget {
  const ContactItemWidget({
    Key? key,
    required this.contactItem,
    required this.onDeletePressed,
  }) : super(key: key);

  final ContactItem contactItem;
  final Function onDeletePressed;
  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
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
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                contactItem.contactName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  LineIcon.user(
                    size: screenHeight * 0.06,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  AutoSizeText(
                    '${'phoneLabel'.tr}: ',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(
                    width: 70,
                    child: AutoSizeText(
                      contactItem.contactNumber,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 1,
                    ),
                  ),
                ],
              )
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.delete,
              size: 35,
              color: Colors.red,
            ),
            onPressed: () => onDeletePressed(),
          ),
        ],
      ),
    );
  }
}
