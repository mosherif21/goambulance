import 'package:flutter/material.dart';

class RegularCard extends StatelessWidget {
  const RegularCard({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          child: child),
    );
  }
}
