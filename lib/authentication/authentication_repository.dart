import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/exception_errors/password_reset_exceptions.dart';
import 'package:goambulance/src/constants/app_init_constants.dart';
import 'package:goambulance/src/features/account/components/models.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../src/constants/enums.dart';
import '../src/general/general_functions.dart';
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
  final isGoogleLinked = false.obs;
  final isEmailAndPasswordLinked = false.obs;
  final isFacebookLinked = false.obs;
  final isEmailVerified = false.obs;

  String verificationId = '';
  GoogleSignIn? googleSignIn;
  UserType userType = UserType.patient;
  late UserInformation userInfo;
  final drawerProfileImageUrl = ''.obs;
  final drawerAccountName = ''.obs;

  @override
  void onInit() {
    fireUser = Rx<User?>(_auth.currentUser);
    if (fireUser.value != null) {
      isUserLoggedIn = true;
      checkUserHasPhoneNumber();
    }
    fireUser.bindStream(_auth.userChanges());
    fireUser.listen((user) {
      if (user != null) {
        isEmailVerified.value = user.emailVerified;
        checkAuthenticationProviders();
      }
    });

    super.onInit();
  }

  void checkUserHasPhoneNumber() {
    if (fireUser.value!.phoneNumber != null) {
      if (fireUser.value!.phoneNumber!.isPhoneNumber) {
        isUserPhoneRegistered = true;
      }
    }
  }

  void authenticatedSetup() {
    AppInit.currentAuthType.value = AuthType.emailLogin;
    checkUserHasPhoneNumber();
  }

  void checkAuthenticationProviders() {
    final user = fireUser.value!;
    isGoogleLinked.value = user.providerData.any(
        (provider) => provider.providerId == GoogleAuthProvider.PROVIDER_ID);

    isFacebookLinked.value = user.providerData.any(
        (provider) => provider.providerId == FacebookAuthProvider.PROVIDER_ID);

    isEmailAndPasswordLinked.value = user.providerData.any(
        (provider) => provider.providerId == EmailAuthProvider.PROVIDER_ID);
  }

  Future<FunctionStatus> userInit() async {
    final fireStore = FirebaseFirestore.instance;
    final fireStorage = FirebaseStorage.instance;
    final String userId = fireUser.value!.uid;
    final firestoreUsersCollRef = fireStore.collection('users');
    try {
      await firestoreUsersCollRef.doc(userId).get().then((snapshot) async {
        if (snapshot.exists) {
          final userDoc = snapshot.data()!;
          final userTypeValue = userDoc['type'].toString();
          if (userTypeValue == 'medic') {
            isUserRegistered = true;
            userType = UserType.medic;
          } else if (userTypeValue == 'driver') {
            isUserRegistered = true;
            userType = UserType.driver;
          } else if (userTypeValue == 'patient') {
            isUserRegistered = true;
            userInfo = UserInformation(
              name: userDoc['name'].toString(),
              email: userDoc['email'].toString(),
              nationalId: userDoc['nationalId'].toString(),
              birthDate: userDoc['birthdate'].toDate(),
              gender: userDoc['gender'].toString(),
              bloodType: userDoc['bloodType'].toString(),
              diabetic: userDoc['diabetic'].toString(),
              hypertensive: userDoc['hypertensive'].toString(),
              heartPatient: userDoc['heartPatient'].toString(),
              additionalInformation:
                  userDoc['additionalInformation'].toString(),
              sosMessage: userDoc['sosMessage'].toString(),
              criticalUser: userDoc['criticalUser'] as bool,
              phone: userDoc['phone'].toString(),
            );
            drawerAccountName.value = userDoc['name'].toString();
            userType = UserType.patient;
          }
          final profileImageRef =
              fireStorage.ref().child('users/$userId/profilePic');
          drawerProfileImageUrl.value = await profileImageRef.getDownloadURL();

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

  Future<void> updateUserEmailFirestore({required String email}) async {
    final fireStore = FirebaseFirestore.instance;
    final String userId = fireUser.value!.uid;
    final firestoreUsersCollRef = fireStore.collection('users');
    try {
      await firestoreUsersCollRef.doc(userId).update({'email': email});
    } on FirebaseException catch (error) {
      if (kDebugMode) print(error.toString());
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }

  Future<String> updateUserEmailAuthentication({required String email}) async {
    try {
      await fireUser.value!.updateEmail(email);
      return 'success';
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'invalid-email') {
        return 'invalidEmailEntered'.tr;
      } else if (ex.code == 'email-already-in-use') {
        return 'emailAlreadyExists'.tr;
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
    return 'unknownError'.tr;
  }

  Future<FunctionStatus> updateUserPhoneFirestore(
      {required String phone}) async {
    final fireStore = FirebaseFirestore.instance;
    final String userId = fireUser.value!.uid;
    final firestoreUsersCollRef = fireStore.collection('users');
    try {
      await firestoreUsersCollRef.doc(userId).update({'phone': phone});
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
        authenticatedSetup();
        isUserLoggedIn = true;
        AppInit.goToInitPage();
        return 'success';
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      if (kDebugMode) print('FIREBASE AUTH EXCEPTION : ${ex.errorMessage}');
      return ex.errorMessage;
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
    return 'unknownError'.tr;
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (fireUser.value != null) {
        authenticatedSetup();
        isUserLoggedIn = true;
        AppInit.goToInitPage();
        return 'success';
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignInWithEmailAndPasswordFailure.code(e.code);
      if (kDebugMode) print('FIREBASE AUTH EXCEPTION : ${ex.errorMessage}');
      return ex.errorMessage;
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
    return 'unknownError'.tr;
  }

  Future<String> linkWithEmailAndPassword(String email, String password) async {
    try {
      final credential =
          EmailAuthProvider.credential(email: email, password: password);
      await fireUser.value!.linkWithCredential(credential);
      return 'success';
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      if (kDebugMode) print('FIREBASE AUTH EXCEPTION : ${ex.errorMessage}');
      return ex.errorMessage;
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
    return 'unknownError'.tr;
  }

  Future<String> signInWithPhoneNumber({
    required String phoneNumber,
    required bool linkWithPhone,
  }) async {
    String returnMessage = 'sent';
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          if (!linkWithPhone) {
            showLoadingScreen();
            await _auth.signInWithCredential(credential);
            if (fireUser.value != null) {
              hideLoadingScreen();
              isUserLoggedIn = true;
              authenticatedSetup();
              AppInit.goToInitPage();
            } else {
              hideLoadingScreen();
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
        },
      );
    } on FirebaseAuthException catch (e) {
      returnMessage = e.code;
    } catch (e) {
      if (kDebugMode) print(e.toString());
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
        await updateUserPhoneFirestore(phone: fireUser.value!.phoneNumber!);
        userInfo.phone = fireUser.value!.phoneNumber!;
        checkUserHasPhoneNumber();
        return 'success';
      } on FirebaseAuthException catch (ex) {
        if (ex.code == 'credential-already-in-use') {
          return 'phoneNumberAlreadyLinked'.tr;
        } else if (ex.code == 'invalid-verification-code') {
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
        authenticatedSetup();
        return 'success';
      }
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'invalid-verification-code') {
        return 'wrongOTP'.tr;
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }

    return 'unknownError'.tr;
  }

  Future<String> signInWithGoogle() async {
    try {
      final googleUser = await getGoogleAuthCredentials();
      if (googleUser != null) {
        await _auth.signInWithCredential(googleUser.credential);
        if (fireUser.value != null) {
          isUserLoggedIn = true;
          authenticatedSetup();
          AppInit.goToInitPage();
          return 'success';
        }
      }
    } on FirebaseAuthException catch (ex) {
      if (kDebugMode) print(ex.code);
    } catch (e) {
      if (kDebugMode) e.printError();
    }
    return 'failedGoogleAuth'.tr;
  }

  void linkWithGoogle() async {
    showLoadingScreen();
    final returnCode = await linkWithGoogleCode();
    hideLoadingScreen();
    if (returnCode == 'successGoogleLink'.tr) {
      showSnackBar(text: returnCode, snackBarType: SnackBarType.success);
    } else {
      showSnackBar(text: returnCode, snackBarType: SnackBarType.error);
    }
  }

  Future<String> linkWithGoogleCode() async {
    try {
      await signOutGoogle();
      final googleUser = await getGoogleAuthCredentials();
      if (googleUser != null) {
        final googleAccountLinked =
            await isGoogleAccountConnectedToFirebaseUser(googleUser.email);
        if (googleAccountLinked) {
          return 'googleAccountInUse'.tr;
        } else {
          if (isGoogleLinked.value) {
            await fireUser.value!.unlink(GoogleAuthProvider.PROVIDER_ID);
          }
          await fireUser.value!.linkWithCredential(googleUser.credential);
          if (!isEmailAndPasswordLinked.value) {
            await updateUserEmailAuthentication(email: googleUser.email);
            await updateUserEmailFirestore(email: googleUser.email);
            userInfo.email = googleUser.email;
          }
        }
        return 'successGoogleLink'.tr;
      } else {
        return 'failedGoogleLink'.tr;
      }
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'credential-already-in-use') {
        return 'googleAccountInUse'.tr;
      } else if (ex.code == 'no-such-provider') {
        return 'failedGoogleLink'.tr;
      }
    } catch (e) {
      if (kDebugMode) e.printError();
    }
    return 'failedGoogleLink'.tr;
  }

  Future<bool> isGoogleAccountConnectedToFirebaseUser(String email) async {
    try {
      final List<String> signInMethods =
          await _auth.fetchSignInMethodsForEmail(email);
      return signInMethods.contains('google.com');
    } catch (e) {
      if (kDebugMode) {
        print(
            'Error checking if Google account is connected to a Firebase user: $e');
      }
      return false;
    }
  }

  Future<void> signOutGoogle() async {
    if (await googleSignIn?.isSignedIn() ?? false) {
      await googleSignIn?.disconnect();
      await googleSignIn?.signOut();
    }
  }

  Future<GoogleUserModel?> getGoogleAuthCredentials() async {
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
        return GoogleUserModel(
            credential: credential, email: googleSignInAccount.email);
      }
    } catch (e) {
      if (kDebugMode) e.printError();
    }
    return null;
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
    try {
      final facebookAuthCredential = await getFacebookAuthCredential();
      if (facebookAuthCredential != null) {
        await _auth.signInWithCredential(facebookAuthCredential);
        if (fireUser.value != null) {
          isUserLoggedIn = true;
          authenticatedSetup();
          AppInit.goToInitPage();
          return 'success';
        }
      }
    } catch (e) {
      if (kDebugMode) e.printError();
    }
    return 'failedFacebookAuth'.tr;
  }

  Future<String> linkWithFacebook(String email, String password) async {
    try {
      final facebookCredential = await getFacebookAuthCredential();
      if (facebookCredential != null) {
        await fireUser.value!.linkWithCredential(facebookCredential);
        return 'success';
      }
    } catch (e) {
      if (kDebugMode) e.printError();
    }
    return 'failedFacebookAuth'.tr;
  }

  Future<OAuthCredential?> getFacebookAuthCredential() async {
    try {
      // if (AppInit.isWeb) {
      //   final facebookProvider = FacebookAuthProvider();
      //   facebookProvider.addScope('email');
      //   facebookProvider.setCustomParameters({
      //     'display': 'popup',
      //   });
      //   await _auth.signInWithPopup(facebookProvider);
      //   if (fireUser.value != null) {
      //     isUserLoggedIn = true;
      //     await authenticatedSetup();
      //     AppInit.goToInitPage();
      //     return 'success';
      //   }
      // } else {}
      final loginResult = await FacebookAuth.instance.login();
      if (loginResult.accessToken?.token != null) {
        final facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        return facebookAuthCredential;
      }
    } catch (e) {
      if (kDebugMode) e.printError();
    }
    return null;
  }

  Future<FunctionStatus> logoutAuthUser() async {
    try {
      await signOutGoogle();
      isUserRegistered = false;
      isUserLoggedIn = false;
      isUserPhoneRegistered = false;
      isGoogleLinked.value = false;
      isEmailAndPasswordLinked.value = false;
      isFacebookLinked.value = false;
      isEmailVerified.value = false;
      verificationId = '';
      userType = UserType.patient;
      userInfo = UserInformation(
        name: '',
        email: '',
        nationalId: '',
        birthDate: DateTime.now(),
        gender: '',
        bloodType: '',
        diabetic: '',
        hypertensive: '',
        heartPatient: '',
        additionalInformation: '',
        sosMessage: '',
        criticalUser: false,
        phone: '',
      );
      drawerProfileImageUrl.value = '';
      return FunctionStatus.success;
    } on FirebaseAuthException catch (ex) {
      if (kDebugMode) print(ex.code);
      return FunctionStatus.failure;
    } catch (e) {
      if (kDebugMode) e.printError();
      return FunctionStatus.failure;
    }
  }
}

class GoogleUserModel {
  final OAuthCredential credential;
  final String email;
  GoogleUserModel({
    required this.credential,
    required this.email,
  });
}
