import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../general/general_functions.dart';
import '../../../controllers/making_request_location_controller.dart';

class MakingRequestMapSearch extends StatelessWidget {
  const MakingRequestMapSearch({
    Key? key,
    required this.makingRequestController,
  }) : super(key: key);
  final MakingRequestLocationController makingRequestController;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => makingRequestController.googlePlacesSearch(context: context),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              color: Colors.grey.shade600,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                if (isLangEnglish()) const SizedBox(width: 10),
                Obx(
                  () => Expanded(
                    child: AutoSizeText(
                      isLangEnglish()
                          ? makingRequestController.searchedText.value
                          : '   ${makingRequestController.searchedText.value}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
