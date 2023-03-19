import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../connectivity/connectivity.dart';
import '../components/home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectivityChecker.checkConnection(displayAlert: true);
    //final homeScreenController = Get.put(HomeScreenController());
    return ChangeNotifierProvider(
      create: (_) => MenuProvider(),
      child: const HomeScreen(),
    );
  }
}
