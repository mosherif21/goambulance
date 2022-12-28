import 'package:get/get.dart';

class SignUpWithEmailAndPasswordFailure {
  final String errorMessage;
  const SignUpWithEmailAndPasswordFailure(
      [this.errorMessage = "An unknown error occurred"]);
  factory SignUpWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return SignUpWithEmailAndPasswordFailure('enterStrongerPassword'.tr);
      case 'invalid-email':
        return SignUpWithEmailAndPasswordFailure('invalidEmailEntered'.tr);
      case 'email-already-in-use':
        return SignUpWithEmailAndPasswordFailure('emailAlreadyExists'.tr);
      case 'operation-not-allowed':
        return SignUpWithEmailAndPasswordFailure('operationNotAllowed'.tr);
      case 'user-disabled':
        return SignUpWithEmailAndPasswordFailure('userDisabled'.tr);
      default:
        return const SignUpWithEmailAndPasswordFailure(
            'An unknown error occurred');
    }
  }
}
