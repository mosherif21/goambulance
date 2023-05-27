import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class EmptyRequestsHistory extends StatelessWidget {
  const EmptyRequestsHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AutoSizeText('no requests');
  }
}
