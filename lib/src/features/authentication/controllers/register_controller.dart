import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();
  final email = TextEditingController();
  final password = TextEditingController();
  final passwordConfirm = TextEditingController();
  void registerNewUser(String email, String password) {
    if (kDebugMode) {
      print('email register data is: email: $email and password: $password');
    }
  }
}
