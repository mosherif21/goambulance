import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../authentication/authentication_repository.dart';

class RegisterUserDataController extends GetxController {
  static RegisterUserDataController get instance => Get.find();
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final genderTextController = TextEditingController();
  final nationalIdTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final user = AuthenticationRepository.instance.fireUser.value;
    final userEmail = user?.email ?? '';
    final userName = user?.displayName ?? '';
    nameTextController.text = userName;
    emailTextController.text = userEmail;
  }
}
