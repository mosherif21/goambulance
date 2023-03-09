import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/exception_errors/password_reset_exceptions.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/general/common_functions.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../src/features/authentication/screens/auth_screen.dart';
import '../src/features/home_page/screens/home_page_screen.dart';
import 'exception_errors/signin_email_password_exceptions.dart';
import 'exception_errors/signup_email_password_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //vars
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> fireUser;
  bool isUserLoggedIn = false;
  var verificationId = ''.obs;
  GoogleSignIn? googleSignIn;
  @override
  void onInit() {
    super.onInit();
    fireUser = Rx<User?>(_auth.currentUser);
    if (fireUser.value != null) {
      isUserLoggedIn = true;
    }
    fireUser.bindStream(_auth.userChanges());
  }

  @override
  void onReady() {
    if (AppInit.initialInternetConnectionStatus ==
        InternetConnectionStatus.disconnected) {
      isUserLoggedIn
          ? Get.offAll(() => const HomePageScreen())
          : Get.offAll(() => const AuthenticationScreen());
    }
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (fireUser.value != null) {
        await authenticatedSetup().whenComplete(() => getToHomePage());
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
        await authenticatedSetup().whenComplete(() => getToHomePage());
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
            final auth = await _auth.signInWithCredential(credential);
            if (auth.user != null) {
              getToHomePage();
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
    UserCredential credentials;
    try {
      credentials = await _auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: verificationId.value, smsCode: otp));
      if (credentials.user != null) {
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
        GoogleSignInAuthentication? signInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: signInAuthentication.idToken,
          accessToken: signInAuthentication.accessToken,
        );
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          getToHomePage();
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
        //web facebook login
        FacebookAuthProvider facebookProvider = FacebookAuthProvider();
        facebookProvider.addScope('email');
        facebookProvider.setCustomParameters({
          'display': 'popup',
        });
        // Once signed in, return the UserCredential
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithPopup(facebookProvider);
        if (userCredential.user != null) {
          getToHomePage();
          return 'success';
        }
      } catch (e) {
        if (kDebugMode) e.printError();
      }
    } else {
      try {
        final LoginResult loginResult = await FacebookAuth.instance.login();
        if (loginResult.accessToken?.token != null) {
          // Create a credential from the access token
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(loginResult.accessToken!.token);
          // Once signed in, return the UserCredential
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential);
          if (userCredential.user != null) {
            getToHomePage();
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
