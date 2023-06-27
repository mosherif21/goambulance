import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeEnableLocationButton extends StatelessWidget {
  const EmployeeEnableLocationButton({super.key, required this.onPressed});
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      color: Colors.white,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        splashFactory: InkSparkle.splashFactory,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              const Icon(Icons.location_off_outlined, size: 25),
              const SizedBox(width: 5),
              AutoSizeText(
                'enableLocationServiceButton'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
        onTap: () => onPressed(),
      ),
    );
  }
}
