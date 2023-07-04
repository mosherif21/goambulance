import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';

import '../../../../general/general_functions.dart';
import '../models.dart';

class MedicalHistoryItem extends StatelessWidget {
  const MedicalHistoryItem({
    Key? key,
    required this.diseaseItem,
    required this.onDeletePressed,
    required this.onEditPressed,
  }) : super(key: key);

  final DiseaseItem diseaseItem;
  final Function onDeletePressed;
  final Function onEditPressed;

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
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
      child: Row(
        children: [
          LineIcon.medicalNotes(
            size: screenHeight * 0.06,
            color: Colors.black,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                diseaseItem.diseaseName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  if (diseaseItem.diseaseMedicines.isNotEmpty)
                    AutoSizeText(
                      '${'medicineName'.tr}: ',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                    ),
                  if (diseaseItem.diseaseMedicines.isNotEmpty)
                    SizedBox(
                      width: 60,
                      child: AutoSizeText(
                        diseaseItem.diseaseMedicines,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
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
          Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.remove_circle,
                  size: 35,
                  color: Colors.red,
                ),
                onPressed: () => onDeletePressed(),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  size: 35,
                  color: Colors.blue,
                ),
                onPressed: () => onEditPressed(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
