import 'package:flutter/material.dart';

import '../constants/sizes.dart';

class RegularBottomSheet {
  final BuildContext context;
  final Widget child;
  const RegularBottomSheet({required this.child, required this.context});
  void showRegularBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Wrap(
        children: [
          Container(
            padding: const EdgeInsets.all(kDefaultPaddingSize),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
