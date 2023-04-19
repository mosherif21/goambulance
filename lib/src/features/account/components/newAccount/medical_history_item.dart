import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../constants/assets_strings.dart';
import '../../../../general/general_functions.dart';
import '../models.dart';

class MedicalHistoryItem extends StatelessWidget {
  const MedicalHistoryItem({
    Key? key,
    required this.diseaseItem,
    required this.onDeletePressed,
  }) : super(key: key);

  final DiseaseItem diseaseItem;
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
                diseaseItem.diseaseName,
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
                  SvgPicture.asset(
                    kMedicalHistoryItemImg,
                    height: screenHeight * 0.06,
                  ),
                  const SizedBox(height: 10),
                  if (diseaseItem.diseaseMedicines.isNotEmpty)
                    AutoSizeText(
                      '${'medicineName'.tr}: ',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                    ),
                  if (diseaseItem.diseaseMedicines.isNotEmpty)
                    Expanded(
                      child: AutoSizeText(
                        diseaseItem.diseaseMedicines,
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
              size: 40,
              color: Colors.red,
            ),
            onPressed: () => onDeletePressed(),
          ),
        ],
      ),
    );
  }
}
