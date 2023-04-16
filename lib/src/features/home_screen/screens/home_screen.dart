import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../firebase_files/firebase_patient_access.dart';
import '../../../connectivity/connectivity.dart';
import '../components/home_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectivityChecker.checkConnection(displayAlert: true);
    Get.put(FirebasePatientDataAccess());
    return const HomeNavigationDrawer();
  }
}
