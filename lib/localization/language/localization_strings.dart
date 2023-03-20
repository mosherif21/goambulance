import 'package:get/get.dart';

class Languages extends Translations {
  // Map<String, Map<String, String>> get keys => {
  //   'en_US': {
  //     'logged_in': 'logged in as @name with email @email',
  //   },
  //   'es_ES': {
  //     'logged_in': 'iniciado sesión como @name con e-mail @email',
  //   }
  // };
  //
  // Text('logged_in'.trParams({
  // 'name': 'Jhon',
  // 'email': 'jhon@example.com'
  // }));
  @override
  Map<String, Map<String, String>> get keys => {
        'ar_SA': {
          'onBoardingTitle1': 'خدمة اسعاف سريعة',
          'onBoardingTitle2': 'خدمة عملاء',
          'onBoardingTitle3': 'نصلك اينما كنت',
          'onBoardingSubTitle1': 'نجعل كل ثانية مهمة',
          'onBoardingSubTitle2': 'خدمة عملاء على مدار ال24 ساعة',
          'onBoardingSubTitle3': '',
          'welcomeTitle': 'Goambulance',
          'welcomeSubTitle': 'المساعدة بضغطةواحدة',
          'loginTextTitle': 'تسجيل الدخول',
          'registerTextTitle': 'انشاء حساب',
          'skipLabel': 'التخطى',
          'notAvailableErrorTitle': 'غير متاح حاليا',
          'notAvailableErrorSubTitle': 'نحن نعمل على اصلاح الوضع....',
          'noConnectionAlertTitle': 'لا يوجد اتصال',
          'noConnectionAlertContent': 'برجاء التاكد من اتصال الانترنت الخاص بك',
          'oK': 'حسنا',
          'loginWithGoogle': 'اكمل عن طريق جوجل',
          'loginWithFacebook': 'اكمل عن طريق فيسبوك',
          'loginWithMobile': 'اكمل برقم الهاتف',
          'emailLabel': 'البريد الالكترونى',
          'emailHintLabel': 'ادخل بريدك الالكترونى',
          'passwordLabel': 'كلمة المرور',
          'passwordHintLabel': 'ادخل كلمة المرور',
          'forgotPassword': 'لا تتذكر كلمة المرور؟',
          'alternateLoginLabel': 'او عن طريق',
          'noEmailAccount':
              'ليس لديك حساب بريد الكترونى؟ انشئ حساب بريد الكترونى',
          'english': 'الانجليزية',
          'arabic': 'العربية',
          'chooseLanguage': 'اختر لغتك المفضلة',
          'chooseForgetPasswordMethod': 'اختر طريقة تغيير كلمة المرور',
          'emailReset': 'تغيير كلمة المرور عن طريق لينك البريد الكترونى',
          'numberReset': 'تغيير البريد الكترونى عن طريق كود برقم الهاتف',
          'phoneLabel': 'رقم الهاتف',
          'phoneFieldLabel': 'ادخل رقم هاتفك',
          'emailVerification':
              'ادخل البريد الكترونى للحصول على رابط تغيير كلمة المرور',
          'phoneVerification': 'ادخل رقم الهاتف للحصول على رمز التاكيد',
          'continue': 'اكمل',
          'verificationCode': 'رمز تاكيد',
          'verificationCodeShare': 'لا تشارك الرمز المرسل اليك مع احد!',
          'confirm': 'تاكيد',
          'confirmPassword': 'تاكيد كلمة المرور',
          'alreadyHaveAnAccount': 'لديك حساب بالفعل؟ قم بتسجيل الدخول من هنا',
          'invalidEmail': 'بريد الكترونى خاطئ',
          'invalidEmailEntered': 'بريد الالكترونى غير صحيح',
          'missingEmail': 'ادخل بريدك الالكترونى',
          'noRegisteredEmail': 'لا يوجد مستخدم بذلك البريد الاكترونى',
          'unknownError': 'حدث خطا غير معروف',
          'wrongPassword': 'كلمة المرور خاطئة',
          'enterStrongerPassword': 'ادخل كلمة مرور اكثر امانا',
          'emailAlreadyExists': 'البريد الالكترونى مستخدم',
          'operationNotAllowed': 'محاولة غير مسموح بها',
          'userDisabled': 'هذا المستخدم ممنوع من الاستخدام',
          'invalidPhoneNumber': 'رقم الهاتف غير صحيح',
          'wrongOTP': 'رمز التاكيد غير صحيح',
          'failedGoogleAuth': 'تسجيل الدخول بجوجل فشل, حاول مرة اخرى',
          'failedFacebookAuth': 'تسجيل الدخول بفيسبوك فشل, حاول مرة اخرى',
          'failedAuth': 'فشل تسجيل الدخول',
          'success': 'محاولة ناجحة',
          'error': 'حدث خطا',
          'home': 'الرئيسية',
          'search': 'البحث',
          'settings': 'الاعدادات',
          'account': 'الحساب',
          'requests': 'الطلبات',
          'help': 'المساعدة',
          'emailResetSuccess': 'تم ارسال رابط تغيير كلمة المرور بنجاح',
          'emptyFields': 'لا يمكن أن تكون الخانات فارغة',
          'smallPass': 'لا يمكن أن تكون كلمة المرور أقل من 8 أحرف',
          'passwordNotMatch': 'كلمات المرور غير متطابقة',
          'lang': 'العربية',
          'logout': 'تسجيل الخروج',
          'qrCode': 'رمز الاستجابة السريع',
          'qrCodeEnter': 'اضف عن طريق رمز الاستجابة السريع',
          'normalRequest': 'طلب عادى',
          'sosRequest': 'طلب طارئ',
          'services': 'الخدمات',
          'recentRequests': 'الطلبات السابقة',
          'firstAidTips': 'نصائح الإسعافات الأولية',
          'viewAll': 'عرض الكل',
          'payment': 'الدفع',
          'promos': 'العروض',
          'notifications': 'الاشعارات',
          'aboutUs': 'معلومات عنا',
          'locationService': 'خدمة الموقع',
          'enableLocationService': 'يرجى تمكين خدمة الموقع لاستخدام التطبيق',
          'locationPermission': 'إذن الموقع',
          'enableLocationPermission': 'يرجى قبول إذن الموقع لاستخدام التطبيق',
          'locationPermissionDeniedForever':
              'تم رفض إذن المواقع إلى الأبد ، يرجى تمكينه من الإعدادات',
          'firstAidTips1': 'عضت كلب',
          'firstAidTips2': 'حرق',
          'firstAidTips3': 'صعق بالكهرباء',
          'firstAidTips4': 'كسر في العظام',
          'firstAidTips5': 'نزيف في الانف',
          'firstAidTips6': 'جرح',
        },
        'en_US': {
          'onBoardingTitle1': 'Fast ambulance requests',
          'onBoardingTitle2': 'Customer Service',
          'onBoardingTitle3': 'Any Location',
          'onBoardingSubTitle1': 'We make every second count',
          'onBoardingSubTitle2': '24/7 available customer service',
          'onBoardingSubTitle3': 'Wherever you are, we are here for you',
          'welcomeTitle': 'Goambulance',
          'welcomeSubTitle': 'Help is one click away',
          'loginTextTitle': 'LOGIN',
          'registerTextTitle': 'REGISTER',
          'skipLabel': 'Skip',
          'notAvailableErrorTitle': 'Not Currently Available',
          'notAvailableErrorSubTitle': 'We are working on it....',
          'noConnectionAlertTitle': 'No Connection',
          'noConnectionAlertContent': 'Please check your internet connectivity',
          'oK': 'OK',
          'loginWithGoogle': 'CONTINUE WITH GOOGLE',
          'loginWithFacebook': 'CONTINUE WITH FACEBOOK',
          'loginWithMobile': 'CONTINUE WITH PHONE NUMBER',
          'emailLabel': 'E-Mail',
          'emailHintLabel': 'Enter your E-Mail',
          'passwordLabel': 'Password',
          'passwordHintLabel': 'Enter your Password',
          'forgotPassword': 'Forgot Password?',
          'alternateLoginLabel': 'OR',
          'noEmailAccount': 'Don\'t have an email account? Register with email',
          'english': 'ENGLISH',
          'arabic': 'ARABIC',
          'chooseLanguage': 'Choose your preferred language',
          'chooseForgetPasswordMethod':
              'Choose a method to reset your password',
          'emailReset': 'Reset password via E-Mail Link',
          'numberReset': 'Reset password via Phone OTP Verification',
          'phoneLabel': 'Phone Number',
          'phoneFieldLabel': 'Enter your Phone Number',
          'emailVerification': 'Enter your E-Mail to get the verification code',
          'phoneVerification':
              'Enter your Phone Number to get the verification code',
          'continue': 'CONTINUE',
          'verificationCode': 'Verification Code',
          'verificationCodeShare':
              'Don\'t share the verification code sent to you with anyone!',
          'confirm': 'Confirm',
          'confirmPassword': 'Confirm Password',
          'alreadyHaveAnAccount': 'Already Have an account? Login here',
          'invalidEmail': 'Invalid Email',
          'invalidEmailEntered': 'Email entered is invalid',
          'missingEmail': 'No Email entered',
          'noRegisteredEmail': 'There is no account with this email registered',
          'unknownError': 'An unknown error occurred. Try again',
          'wrongPassword': 'Password entered is wrong',
          'enterStrongerPassword': 'Please enter a stronger password',
          'emailAlreadyExists': 'This email already exists',
          'operationNotAllowed': 'Operation now allowed. Contact Support',
          'userDisabled': 'This user is disabled',
          'invalidPhoneNumber': 'Entered phone number is invalid',
          'wrongOTP': 'Entered OTP is wrong',
          'failedGoogleAuth': 'Google authentication failed, Please try again',
          'failedFacebookAuth':
              'Facebook authentication failed, Please try again',
          'failedAuth': 'Authentication failed',
          'success': 'Success',
          'error': 'Error',
          'home': 'Home',
          'search': 'Search',
          'settings': 'Settings',
          'account': 'Account',
          'requests': 'Requests',
          'help': 'Help',
          'emailResetSuccess': 'Reset email sent successfully',
          'emptyFields': 'Fields can\'t be empty',
          'smallPass': 'Password can\'t be less than 8 characters',
          'passwordNotMatch': 'Passwords doesn\'t match',
          'lang': 'ENG',
          'logout': 'Logout',
          'qrCode': 'Qr code',
          'qrCodeEnter': 'Add using qr code',
          'normalRequest': 'Normal Request',
          'sosRequest': 'SOS Request',
          'services': 'Services',
          'recentRequests': 'Recent requests',
          'firstAidTips': 'First aid tips',
          'viewAll': 'See All',
          'payment': 'Payment',
          'promos': 'Promos',
          'notifications': 'Notifications',
          'aboutUs': 'About Us',
          'locationService': 'Location Service',
          'enableLocationService':
              'Please enable location service to use the app',
          'locationPermission': 'Location permission',
          'enableLocationPermission':
              'Please accept locations permission to use the app',
          'locationPermissionDeniedForever':
              'Locations permission denied forever please enable it from the settings',
          'firstAidTips1': 'Dog Bite',
          'firstAidTips2': 'Burn',
          'firstAidTips3': 'Electrocute',
          'firstAidTips4': 'Bone Fracture',
          'firstAidTips5': 'Nose Bleed',
          'firstAidTips6': 'Wounded',
        },
      };
}
