import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:goambulance/localization/language/language_functions.dart';

import '../../../../../general/general_functions.dart';
import '../../../controllers/making_request_controller.dart';

class MakingRequestMapSearch extends StatelessWidget {
  const MakingRequestMapSearch({
    Key? key,
    required this.makingRequestController,
  }) : super(key: key);
  final MakingRequestController makingRequestController;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => makingRequestController.googlePlacesSearch(context: context),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.all(Radius.circular(15.0))),
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
                      locale: getLocale(),
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
