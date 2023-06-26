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
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.only(
            bottom: 15.0, left: 15.0, right: 15.0, top: 5.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300, //New
              blurRadius: 2.0,
            )
          ],
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
