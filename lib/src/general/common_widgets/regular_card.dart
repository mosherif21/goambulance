import 'package:flutter/material.dart';

class RegularCard extends StatelessWidget {
  const RegularCard({
    Key? key,
    required this.child,
    required this.highlightRed,
  }) : super(key: key);
  final Widget child;
  final bool highlightRed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          border: highlightRed
              ? const Border(
                  top: BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                  left: BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                  right: BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                  bottom: BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                )
              : const Border(),
        ),
        child: child,
      ),
    );
  }
}
