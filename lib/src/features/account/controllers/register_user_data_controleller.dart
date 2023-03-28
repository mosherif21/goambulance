import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RegisterUserDataController extends GetxController {
  static RegisterUserDataController get instance => Get.find();
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final genderTextController = TextEditingController();
  final nationalIdTextController = TextEditingController();
}
