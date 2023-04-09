import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/exception_errors/password_reset_exceptions.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'exception_errors/signin_email_password_exceptions.dart';
import 'exception_errors/signup_email_password_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //vars
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> fireUser;
  bool isUserLoggedIn = false;
  bool isUserRegistered = false;
  var verificationId = ''.obs;
  GoogleSignIn? googleSignIn;

  UserType userType = UserType.user;

  @override
  void onInit() {
    super.onInit();
    fireUser = Rx<User?>(_auth.currentUser);
    if (fireUser.value != null) {
      isUserLoggedIn = true;
    }
    fireUser.bindStream(_auth.userChanges());
  }

  Future<FunctionStatus> userInit() async {
    final fireStore = FirebaseFirestore.instance;
    final String userId = fireUser.value!.uid;
    final firestoreUserDocRef = fireStore
        .collection('users')
        .doc('patients')
        .collection('userInfo')
        .doc(userId);
    final firestoreDriverDocRef = fireStore
        .collection('users')
        .doc('ambulanceDrivers')
        .collection('driverInfo')
        .doc(userId);
    try {
      await firestoreDriverDocRef
          .get()
          .then((DocumentSnapshot userSnapshot) async {
        if (userSnapshot.exists) {
          userType = UserType.driver;
          isUserRegistered = true;
        } else {
          await firestoreUserDocRef.get().then((DocumentSnapshot userSnapshot) {
            if (userSnapshot.exists) {
              userType = UserType.user;
              isUserRegistered = true;
            } else {
              userType = UserType.user;
              isUserRegistered = false;
            }
          });
        }
      });
      return FunctionStatus.success;
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
      return FunctionStatus.failure;
    }
  }

  Future<void> authenticatedSetup() async {
    AppInit.currentAuthType.value = AuthType.emailLogin;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (fireUser.value != null) {
        await authenticatedSetup();
        isUserLoggedIn = true;
        AppInit.goToInitPage();
        return 'success';
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      if (kDebugMode) print('FIREBASE AUTH EXCEPTION : ${ex.errorMessage}');
      return ex.errorMessage;
    } catch (_) {}
    return 'default/failed';
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (fireUser.value != null) {
        await authenticatedSetup();
        isUserLoggedIn = true;
        AppInit.goToInitPage();
        return 'success';
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignInWithEmailAndPasswordFailure.code(e.code);
      if (kDebugMode) print('FIREBASE AUTH EXCEPTION : ${ex.errorMessage}');
      return ex.errorMessage;
    } catch (_) {}
    return 'default/failed';
  }

  Future<String> signInWithPhoneNumber(String phoneNumber) async {
    String returnMessage = 'codeSent';
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (credential) async {
            await _auth.signInWithCredential(credential);
            if (fireUser.value != null) {
              isUserLoggedIn = true;
              await authenticatedSetup();
              AppInit.goToInitPage();
            }
          },
          verificationFailed: (e) {
            returnMessage = e.code;
          },
          codeSent: (verificationId, resendToken) {
            this.verificationId.value = verificationId;
          },
          codeAutoRetrievalTimeout: (verificationId) {
            this.verificationId.value = verificationId;
          });
    } on FirebaseAuthException catch (e) {
      returnMessage = e.code;
    } catch (e) {
      returnMessage = e.toString();
    }

    return returnMessage;
  }

  Future<String> verifyOTP(String otp) async {
    try {
      await _auth.signInWithCredential(PhoneAuthProvider.credential(
          verificationId: verificationId.value, smsCode: otp));
      if (fireUser.value != null) {
        isUserLoggedIn = true;
        await authenticatedSetup();
        AppInit.goToInitPage();
        return 'success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code.compareTo('invalid-verification-code') == 0) {
        return 'wrongOTP'.tr;
      }
    } catch (_) {}

    return 'unknownError'.tr;
  }

  Future<String> signInWithGoogle() async {
    try {
      googleSignIn = kIsWeb
          ? GoogleSignIn(
              clientId:
                  '996996980213-nuisd4i1fat65pjs4lu76d2r020fdj9b.apps.googleusercontent.com')
          : GoogleSignIn();
      final googleSignInAccount = await googleSignIn?.signIn();
      if (googleSignInAccount != null) {
        final signInAuthentication = await googleSignInAccount.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: signInAuthentication.idToken,
          accessToken: signInAuthentication.accessToken,
        );
        await _auth.signInWithCredential(credential);
        if (fireUser.value != null) {
          isUserLoggedIn = true;
          await authenticatedSetup();
          AppInit.goToInitPage();
          return 'success';
        }
      }
    } catch (e) {
      if (kDebugMode) e.printError();
    }
    return 'failedGoogleAuth'.tr;
  }

  Future<String> resetPassword({required String email}) async {
    String returnMessage = 'unknownError'.tr;
    try {
      await _auth
          .sendPasswordResetEmail(email: email)
          .whenComplete(() => returnMessage = 'emailSent');
    } on FirebaseAuthException catch (e) {
      final ex = ResetPasswordFailure.code(e.code);
      if (kDebugMode) print('FIREBASE AUTH EXCEPTION : ${ex.errorMessage}');
      return ex.errorMessage;
    } catch (_) {}
    return returnMessage;
  }

  Future<String> signInWithFacebook() async {
    if (AppInit.isWeb) {
      try {
        final facebookProvider = FacebookAuthProvider();
        facebookProvider.addScope('email');
        facebookProvider.setCustomParameters({
          'display': 'popup',
        });
        final userCredential =
            await FirebaseAuth.instance.signInWithPopup(facebookProvider);
        if (userCredential.user != null) {
          isUserLoggedIn = true;
          await authenticatedSetup();
          AppInit.goToInitPage();
          return 'success';
        }
      } catch (e) {
        if (kDebugMode) e.printError();
      }
    } else {
      try {
        final LoginResult loginResult = await FacebookAuth.instance.login();
        if (loginResult.accessToken?.token != null) {
          final facebookAuthCredential =
              FacebookAuthProvider.credential(loginResult.accessToken!.token);
          final userCredential = await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential);
          if (userCredential.user != null) {
            isUserLoggedIn = true;
            await authenticatedSetup();
            AppInit.goToInitPage();
            return 'success';
          }
        } else {
          return 'failedFacebookAuth'.tr;
        }
      } catch (e) {
        if (kDebugMode) e.printError();
      }
    }
    return 'failedFacebookAuth'.tr;
  }

  Future<void> logoutUser() async {
    await googleSignIn?.signOut();
    await _auth.signOut();
  }
}
