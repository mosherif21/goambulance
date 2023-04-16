import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/exception_errors/password_reset_exceptions.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/features/account/components/models.dart';
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
  bool isUserPhoneRegistered = false;
  String verificationId = '';
  GoogleSignIn? googleSignIn;
  UserType userType = UserType.regularUser;
  late UserInformation userInfo;

  @override
  void onInit() {
    super.onInit();
    fireUser = Rx<User?>(_auth.currentUser);
    if (fireUser.value != null) {
      isUserLoggedIn = true;
      checkUserHasPhoneNumber();
    }
    fireUser.bindStream(_auth.userChanges());
  }

  void checkUserHasPhoneNumber() {
    if (fireUser.value!.phoneNumber != null) {
      if (fireUser.value!.phoneNumber!.isPhoneNumber) {
        isUserPhoneRegistered = true;
      }
    }
  }

  Future<void> authenticatedSetup() async {
    AppInit.currentAuthType.value = AuthType.emailLogin;
    checkUserHasPhoneNumber();
  }

  Future<FunctionStatus> userInit() async {
    final fireStore = FirebaseFirestore.instance;
    final String userId = fireUser.value!.uid;
    final firestoreUsersCollRef = fireStore.collection('users');
    try {
      await firestoreUsersCollRef.doc(userId).get().then((snapshot) async {
        if (snapshot.exists) {
          final userDoc = snapshot.data()!;
          final user = userDoc['type'].toString();
          if (user.compareTo('medic') == 0) {
            isUserRegistered = true;
            userType = UserType.medic;
          } else if (user.compareTo('driver') == 0) {
            isUserRegistered = true;
            userType = UserType.driver;
          } else if (user.compareTo('patient') == 0) {
            isUserRegistered = true;
            final List<DiseaseItem> diseasesList = [];
            final diseasesReference = snapshot.reference.collection('diseases');
            await diseasesReference.get().then((diseasesSnapshot) {
              for (var disease in diseasesSnapshot.docs) {
                final diseaseDoc = disease.data();
                diseasesList.add(
                  DiseaseItem(
                    diseaseName: diseaseDoc['diseaseName'].toString(),
                    diseaseMedicines: diseaseDoc['diseaseMedicines'].toString(),
                  ),
                );
              }
            });
            userInfo = UserInformation(
              name: userDoc['name'].toString(),
              email: userDoc['email'].toString(),
              nationalId: userDoc['nationalId'].toString(),
              birthDate: userDoc['birthdate'].toDate(),
              gender: userDoc['gender'].toString(),
              bloodType: userDoc['bloodType'].toString(),
              diabetesPatient: userDoc['diabetesPatient'].toString(),
              bloodPressurePatient: userDoc['bloodPressurePatient'].toString(),
              heartPatient: userDoc['heartPatient'].toString(),
              additionalInformation:
                  userDoc['additionalInformation'].toString(),
              phoneNumber: userDoc['phoneNo'].toString(),
              diseasesList: diseasesList,
            );
            if (userDoc['criticalUser'] as bool) {
              userType = UserType.criticalUser;
            } else {
              userType = UserType.regularUser;
            }
          }
          if (kDebugMode) print('$userType');
        }
      });

      return FunctionStatus.success;
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
      return FunctionStatus.failure;
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return FunctionStatus.failure;
    }
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
    return 'unknownError'.tr;
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
    return 'unknownError'.tr;
  }

  Future<String> signInWithPhoneNumber(
      {required String phoneNumber, required bool linkWithPhone}) async {
    String returnMessage = 'codeSent';
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (credential) async {
            await _auth.signInWithCredential(credential);
            if (fireUser.value != null) {
              isUserLoggedIn = true;
              await authenticatedSetup();
              if (!linkWithPhone) {
                AppInit.goToInitPage();
              }
            }
          },
          verificationFailed: (e) {
            returnMessage = e.code;
          },
          codeSent: (verificationId, resendToken) {
            this.verificationId = verificationId;
          },
          codeAutoRetrievalTimeout: (verificationId) {
            this.verificationId = verificationId;
          });
    } on FirebaseAuthException catch (e) {
      returnMessage = e.code;
    } catch (_) {
      returnMessage = 'unknownError'.tr;
    }

    return returnMessage;
  }

  Future<String> linkPhoneCredentialWithAccount({required String otp}) async {
    if (fireUser.value != null) {
      try {
        final credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: otp);
        await fireUser.value!.updatePhoneNumber(credential);
        checkUserHasPhoneNumber();
        AppInit.goToInitPage();
        return 'success';
      } on FirebaseAuthException catch (ex) {
        if (ex.code.compareTo('credential-already-in-use') == 0) {
          return 'phoneNumberAlreadyLinked'.tr;
        } else if (ex.code.compareTo('provider-already-linked') == 0) {
          return 'phoneNumberAlreadyYourAccount'.tr;
        } else if (ex.code.compareTo('invalid-verification-code') == 0) {
          return 'wrongOTP'.tr;
        }
      } catch (e) {
        if (kDebugMode) print(e.toString());
      }
    }
    return 'unknownError'.tr;
  }

  Future<String> signInVerifyOTP({required String otp}) async {
    try {
      await _auth.signInWithCredential(PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp));
      if (fireUser.value != null) {
        isUserLoggedIn = true;
        await authenticatedSetup();
        AppInit.goToInitPage();
        return 'success';
      }
    } on FirebaseAuthException catch (ex) {
      if (ex.code.compareTo('invalid-verification-code') == 0) {
        return 'wrongOTP'.tr;
      }
    } catch (_) {}

    return 'unknownError'.tr;
  }

  Future<String> signInWithGoogle() async {
    try {
      googleSignIn = AppInit.isWeb
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
    isUserRegistered = false;
    isUserLoggedIn = false;
    isUserPhoneRegistered = false;
    verificationId = '';
    userType = UserType.regularUser;
  }
}
