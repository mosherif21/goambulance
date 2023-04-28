import 'package:flutter/material.dart';
import 'package:goambulance/src/general/general_functions.dart';
import 'package:shimmer/shimmer.dart';

class LoadingContacts extends StatelessWidget {
  const LoadingContacts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300, //New
                  blurRadius: 2.0,
                )
              ],
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            ),
            height: screenHeight * 0.2,
            width: double.infinity,
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300, //New
                  blurRadius: 2.0,
                )
              ],
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            ),
            height: screenHeight * 0.3,
            width: double.infinity,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Container(
              height: 50,
              width: double.infinity,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
