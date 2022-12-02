import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final email = TextEditingController();
  final password = TextEditingController();
  void loginUser(String email, String password) {
    if (kDebugMode) {
      print('login data is: email: $email and password: $password');
    }
  }
}
