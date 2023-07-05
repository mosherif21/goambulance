import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goambulance/authentication/exception_errors/password_reset_exceptions.dart';
import 'package:goambulance/src/features/account/components/models.dart';
import 'package:goambulance/src/features/home_screen/controllers/home_screen_controller.dart';
import 'package:goambulance/src/general/app_init.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../src/constants/enums.dart';
import '../src/general/general_functions.dart';
import 'exception_errors/signin_email_password_exceptions.dart';
import 'exception_errors/signup_email_password_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //vars
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late final Rx<User?> fireUser;
  bool isUserLoggedIn = false;
  bool isUserRegistered = false;
  bool isUserPhoneRegistered = false;
  final isGoogleLinked = false.obs;
  final isEmailAndPasswordLinked = false.obs;
  final isFacebookLinked = false.obs;
  final isEmailVerified = false.obs;
  final criticalUserStatus = Rx<CriticalUserStatus>(CriticalUserStatus.non);
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      criticalRequestListener;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      criticalRequestDeniedListener;
  String verificationId = '';
  GoogleSignIn? googleSignIn;
  UserType userType = UserType.patient;
  late UserInformation userInfo;
  late EmployeeUserInformation employeeUserInfo;
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

  Future<FunctionStatus> sendVerificationEmail() async {
    try {
      if (_auth.currentUser != null) {
        await _auth.setLanguageCode(isLangEnglish() ? 'en' : 'ar');
        await _auth.currentUser!.sendEmailVerification();
        await _auth.setLanguageCode('en');
        return FunctionStatus.success;
      }
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        AppInit.logger.e(error.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
    }
    return FunctionStatus.failure;
  }

  void initCriticalUserListeners() {
    try {
      _firestore
          .collection('criticalUserRequests')
          .doc(fireUser.value!.uid)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          criticalUserStatus.value = CriticalUserStatus.criticalUserPending;
        }
      });
      criticalRequestListener = _firestore
          .collection('users')
          .doc(fireUser.value!.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          final isCritical = snapshot.data()!['criticalUser'] as bool;
          userInfo.criticalUser = isCritical;
          if (isCritical) {
            userInfo.criticalUser = true;
            criticalUserStatus.value = CriticalUserStatus.criticalUserAccepted;
          }
        }
      });
      criticalRequestDeniedListener = _firestore
          .collection('declinedCriticalUserRequests')
          .doc(fireUser.value!.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          criticalUserStatus.value = CriticalUserStatus.criticalUserDenied;
        }
      });
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        AppInit.logger.e(error.toString());
      }
    } catch (err) {
      if (kDebugMode) {
        AppInit.logger.e(err.toString());
      }
    }
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
    final String userId = fireUser.value!.uid;
    final firestoreUsersCollRef = _firestore.collection('users');
    try {
      await firestoreUsersCollRef.doc(userId).get().then((snapshot) async {
        if (snapshot.exists) {
          final userDoc = snapshot.data()!;
          final userTypeValue = userDoc['type'].toString();
          if (userTypeValue == 'ambulanceMedic' ||
              userTypeValue == 'ambulanceDriver') {
            userType = userTypeValue == 'ambulanceMedic'
                ? UserType.medic
                : UserType.driver;

            employeeUserInfo = EmployeeUserInformation(
              name: userDoc['name'].toString(),
              email: userDoc['email'].toString(),
              nationalId: userDoc['nationalId'].toString(),
              phoneNumber: userDoc['phoneNumber'].toString(),
              hospitalId: userDoc['hospitalId'].toString(),
              userType: userType,
            );
            isUserRegistered = await checkEmployeeImagesRegistered();
          } else if (userTypeValue == 'patient') {
            isUserRegistered = true;
            userInfo = UserInformation(
              name: userDoc['name'].toString(),
              email: userDoc['email'].toString(),
              nationalId: userDoc['nationalId'].toString(),
              birthDate: userDoc['birthdate'].toDate(),
              gender: userDoc['gender'].toString(),
              sosMessage: userDoc['sosMessage'].toString(),
              criticalUser: userDoc['criticalUser'] as bool,
              phoneNumber: userDoc['phoneNumber'].toString(),
              backupNumber: userDoc['backupNumber'].toString(),
            );
            userType = UserType.patient;
            criticalUserStatus.value = userInfo.criticalUser
                ? CriticalUserStatus.criticalUserAccepted
                : CriticalUserStatus.non;
            if (!userInfo.criticalUser) {
              initCriticalUserListeners();
            }
            loadProfilePicUrl();
          }
          if (kDebugMode) {
            AppInit.logger.i(userType);
          }
          drawerAccountName.value = userType == UserType.patient
              ? userInfo.name
              : employeeUserInfo.name;
          if (AppInit.notificationToken.isNotEmpty) {
            await _firestore.collection('fcmTokens').doc(userId).set({
              'fcmToken${AppInit.isAndroid ? 'Android' : 'Ios'}':
                  AppInit.notificationToken,
              'notificationsLang': isLangEnglish() ? 'en' : 'ar',
            });
          }
          if (fireUser.value!.email != null) {
            final authenticationEmail = fireUser.value!.email!;
            if (userType == UserType.patient) {
              if (authenticationEmail.isNotEmpty &&
                  userInfo.email != authenticationEmail) {
                if (kDebugMode) {
                  AppInit.logger.i(
                      'Firestore email is not equal to Authentication email, updating it...');
                }
                updateUserEmailFirestore(email: authenticationEmail);
              }
            } else {
              if (authenticationEmail.isNotEmpty &&
                  employeeUserInfo.email != authenticationEmail) {
                if (kDebugMode) {
                  AppInit.logger.i(
                      'Firestore email is not equal to Authentication email, updating it...');
                }
                updateUserEmailFirestore(email: authenticationEmail);
              }
            }
          }
        }
      });
      return FunctionStatus.success;
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        AppInit.logger.i(error.toString());
      }
      return FunctionStatus.failure;
    } catch (e) {
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
      return FunctionStatus.failure;
    }
  }

  Future<void> updateUserEmailFirestore({required String email}) async {
    final String userId = fireUser.value!.uid;
    final firestoreUsersCollRef = _firestore.collection('users');
    try {
      await firestoreUsersCollRef.doc(userId).update({'email': email});
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        AppInit.logger.e(error.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
    }
  }

  Future<String> updateUserEmailAuthentication({required String email}) async {
    try {
      await fireUser.value!.updateEmail(email);
      return 'success';
    } on FirebaseAuthException catch (ex) {
      if (kDebugMode) {
        AppInit.logger.e(ex.code);
      }
      if (ex.code == 'invalid-email') {
        return 'invalidEmailEntered'.tr;
      } else if (ex.code == 'email-already-in-use') {
        return 'emailAlreadyExists'.tr;
      } else if (ex.code == 'missing-email') {
        return 'missingEmail'.tr;
      } else if (ex.code == 'requires-recent-login') {
        return 'requireRecentLoginError'.tr;
      }
    } catch (e) {
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
    }
    return 'unknownError'.tr;
  }

  Future<FunctionStatus> updateUserPhoneFirestore(
      {required String phone}) async {
    final String userId = fireUser.value!.uid;
    final firestoreUsersCollRef = _firestore.collection('users');
    try {
      await firestoreUsersCollRef.doc(userId).update({'phoneNumber': phone});
      return FunctionStatus.success;
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        AppInit.logger.e(error.toString());
      }
      return FunctionStatus.failure;
    } catch (e) {
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
      return FunctionStatus.failure;
    }
  }

  Future<void> loadProfilePicUrl() async {
    if (drawerProfileImageUrl.value.isEmpty) {
      final fireStorage = FirebaseStorage.instance;
      final String userId = fireUser.value!.uid;
      final profileImageRef =
          fireStorage.ref().child('users/$userId/profilePic');
      drawerProfileImageUrl.value = await profileImageRef.getDownloadURL();
    }
  }

  Future<bool> checkEmployeeImagesRegistered() async {
    final fireStorage = FirebaseStorage.instance;
    final String userId = fireUser.value!.uid;
    final profileImageRef = fireStorage.ref().child('users/$userId/profilePic');
    final nationalImageRef =
        fireStorage.ref().child('users/$userId/nationalId');
    try {
      drawerProfileImageUrl.value = await profileImageRef.getDownloadURL();
      final hasNationalImage = await nationalImageRef.getDownloadURL();
      return hasNationalImage.isNotEmpty &&
          drawerProfileImageUrl.value.isNotEmpty;
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        AppInit.logger.i(error.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
    }
    return false;
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
      if (kDebugMode) {
        AppInit.logger.e('FIREBASE AUTH EXCEPTION : ${ex.errorMessage}');
      }
      return ex.errorMessage;
    } catch (e) {
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
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

      if (kDebugMode) {
        AppInit.logger.e('FIREBASE AUTH EXCEPTION : ${ex.errorMessage}');
      }

      return ex.errorMessage;
    } catch (e) {
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
    }
    return 'unknownError'.tr;
  }

  Future<String> linkWithEmailAndPassword(String email, String password) async {
    try {
      final credential =
          EmailAuthProvider.credential(email: email, password: password);
      await fireUser.value!.linkWithCredential(credential);
      await fireUser.value!.reauthenticateWithCredential(credential);
      await fireUser.value!.updateEmail(email);
      await updateUserEmailFirestore(email: email);
      userType == UserType.patient
          ? userInfo.email = email
          : employeeUserInfo.email = email;
      return 'success';
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      if (kDebugMode) {
        AppInit.logger.e('FIREBASE AUTH EXCEPTION : ${e.toString()}');
      }
      return ex.errorMessage;
    } catch (e) {
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
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
      if (kDebugMode) {
        AppInit.logger.e(e.code);
      }
    } catch (e) {
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
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
        if (isUserRegistered) {
          if (Get.isRegistered<HomeScreenController>()) {
            userInfo.phoneNumber = fireUser.value!.phoneNumber!;
          } else {
            employeeUserInfo.phoneNumber = fireUser.value!.phoneNumber!;
          }

          await updateUserPhoneFirestore(phone: fireUser.value!.phoneNumber!);
        }
        checkUserHasPhoneNumber();
        return 'success';
      } on FirebaseAuthException catch (ex) {
        if (kDebugMode) {
          AppInit.logger.e(ex.code);
        }
        if (ex.code == 'credential-already-in-use') {
          return 'phoneNumberAlreadyLinked'.tr;
        } else if (ex.code == 'invalid-verification-code') {
          return 'wrongOTP'.tr;
        }
      } catch (e) {
        if (kDebugMode) {
          AppInit.logger.e(e.toString());
        }
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
      if (kDebugMode) {
        AppInit.logger.e(ex.code);
      }
      if (ex.code == 'invalid-verification-code') {
        return 'wrongOTP'.tr;
      }
    } catch (e) {
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
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
      if (kDebugMode) {
        AppInit.logger.e(ex.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
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
            await fireUser.value!
                .reauthenticateWithCredential(googleUser.credential);
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
      if (kDebugMode) {
        AppInit.logger.e(ex.code);
      }
      if (ex.code == 'credential-already-in-use') {
        return 'googleAccountInUse'.tr;
      } else if (ex.code == 'no-such-provider') {
        return 'failedGoogleLink'.tr;
      }
    } catch (e) {
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
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
        AppInit.logger.e(
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
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
    }
    return null;
  }

  Future<String> changeEmail(String newEmail, String password) async {
    try {
      final credential = EmailAuthProvider.credential(
          email: fireUser.value!.email!, password: password);
      await fireUser.value!.reauthenticateWithCredential(credential);
      await fireUser.value!.updateEmail(newEmail);
      await updateUserEmailFirestore(email: newEmail);
      userType == UserType.patient
          ? userInfo.email = newEmail
          : employeeUserInfo.email = newEmail;
      return 'success';
    } on FirebaseAuthException catch (ex) {
      if (kDebugMode) {
        AppInit.logger.e('FIREBASE AUTH EXCEPTION : ${ex.toString()}');
      }
      if (ex.code == 'invalid-email') {
        return 'invalidEmailEntered'.tr;
      } else if (ex.code == 'email-already-in-use') {
        return 'emailAlreadyExists'.tr;
      } else if (ex.code == 'missing-email') {
        return 'missingEmail'.tr;
      } else if (ex.code == 'user-not-found') {
        return 'noRegisteredEmail'.tr;
      } else if (ex.code == 'wrong-password') {
        return 'wrongPassword'.tr;
      } else if (ex.code == 'requires-recent-login') {
        return 'requireRecentLoginError'.tr;
      }
    } catch (e) {
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
    }
    return 'unknownError'.tr;
  }

  Future<String> resetPassword({required String email}) async {
    String returnMessage = 'unknownError'.tr;
    try {
      await _auth.setLanguageCode(isLangEnglish() ? 'en' : 'ar');
      await _auth
          .sendPasswordResetEmail(email: email)
          .whenComplete(() => returnMessage = 'emailSent');
      await _auth.setLanguageCode('en');
    } on FirebaseAuthException catch (e) {
      final ex = ResetPasswordFailure.code(e.code);

      if (kDebugMode) {
        AppInit.logger.e('FIREBASE AUTH EXCEPTION : ${ex.errorMessage}');
      }
      return ex.errorMessage;
    } catch (e) {
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
    }
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
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
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
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
    }

    return 'failedFacebookAuth'.tr;
  }

  Future<OAuthCredential?> getFacebookAuthCredential() async {
    try {
      if (AppInit.isWeb) {
        final facebookProvider = FacebookAuthProvider();
        facebookProvider.addScope('email');
        facebookProvider.setCustomParameters({
          'display': 'popup',
        });
        //   await _auth.signInWithPopup(facebookProvider);
        //   if (fireUser.value != null) {
        //     isUserLoggedIn = true;
        //     await authenticatedSetup();
        //     AppInit.goToInitPage();
        //     return 'success';
        //   }
        // } else {}
        // final loginResult = await FacebookAuth.instance.login();
        // if (loginResult.accessToken?.token != null) {
        //   final facebookAuthCredential =
        //       FacebookAuthProvider.credential(loginResult.accessToken!.token);
        //   return facebookAuthCredential;
      }
    } catch (e) {
      if (kDebugMode) {
        AppInit.logger.e(e.toString());
      }
    }

    return null;
  }

  Future<void> logoutAuthUser() async {
    try {
      await signOutGoogle();
      await _auth.signOut();
      if (userType == UserType.patient &&
          isUserRegistered &&
          !userInfo.criticalUser) {
        await criticalRequestListener?.cancel();
        await criticalRequestDeniedListener?.cancel();
      }
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
        sosMessage: '',
        criticalUser: false,
        phoneNumber: '',
        backupNumber: '',
      );
      employeeUserInfo = EmployeeUserInformation(
        name: '',
        email: '',
        nationalId: '',
        phoneNumber: '',
        hospitalId: '',
        userType: UserType.driver,
      );
      drawerProfileImageUrl.value = '';
    } on FirebaseAuthException catch (ex) {
      if (kDebugMode) {
        AppInit.logger.e(ex.code);
      }
    } catch (e) {
      if (kDebugMode) e.printError();
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
