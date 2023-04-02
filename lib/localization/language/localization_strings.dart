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
          'welcome': 'مرحبا',
          'welcomeTitle': 'تسجيل الدخول او انشاء حساب',
          'loginTextTitle': 'تسجيل الدخول',
          'registerTextTitle': 'انشاء حساب',
          'skipLabel': 'التخطى',
          'notAvailableErrorTitle': 'غير متاح حاليا',
          'notAvailableErrorSubTitle': 'نحن نعمل على اصلاح الوضع....',
          'noConnectionAlertTitle': 'لا يوجد انترنت',
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
          'alternateLoginLabel': 'او',
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
              'ادخل بريدك الالكترونى للحصول على رابط تغيير كلمة المرور',
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
          'lang': 'اللغة',
          'logout': 'تسجيل الخروج',
          'logoutConfirm': 'هل تريد تسجيل الخروج؟',
          'qrCode': 'رمز الاستجابة السريع',
          'qrCodeEnter': 'اضف عن طريق رمز الاستجابة السريع',
          'normalRequest': 'طلب عادى',
          'sosRequest': 'طلب استغاثة',
          'services': 'الخدمات',
          'recentRequests': 'الطلبات السابقة',
          'firstAidTips': 'نصائح الإسعافات الأولية',
          'firstAid': 'الإسعافات الأولية',
          'emergencyNumbers': 'ارقام الطوارئ',
          'viewAll': 'عرض الكل',
          'payment': 'الدفع',
          'back': 'السابق',
          'notifications': 'الاشعارات',
          'aboutUs': 'معلومات عنا',
          'locationService': 'خدمة الموقع',
          'enableLocationService': 'يرجى تمكين خدمة الموقع لاستخدام التطبيق',
          'locationPermission': 'إذن الموقع',
          'enableLocationPermission': 'يرجى قبول إذن الموقع لاستخدام التطبيق',
          'locationPermissionDeniedForever':
              'تم رفض إذن المواقع إلى الأبد ، يرجى تمكينه من الإعدادات',
          'firstAidTips1': 'غياب الوعى',
          'firstAidTips2': 'الانعاش القلبى الرئوى',
          'firstAidTips3': 'انسداد مجرى الهواء',
          'firstAidTips4': 'سكر الدم',
          'firstAidTips5': 'الازمات القلبية',
          'firstAidTips6': 'ازمات الربو',
          'firstAidTips7': 'السكتة الدماغية',
          'firstAidTips8': 'الصرع',
          'firstAidTips9': 'الجروح العميقة',
          'firstAidTips10': 'نزيف الانف',
          'firstAidTips11': 'الكسور والخلع',
          'firstAidTips12': 'الحروق',
          'firstAidTips13': 'الغرق',
          'firstAidTips14': 'التسمم',
          'firstAidTips15': 'التوعية الطبية',
          'firstAidTips16': 'الاجهاد الحرارى',
          'firstAidTips17': 'ضربة الشمس',
          'emergencyNumber1': 'الاسعاف',
          'emergencyNumber2': 'الشرطة',
          'emergencyNumber3': 'الاطفاء',
          'emergencyNumber4': 'طوارئ الغاز',
          'emergencyNumber5': 'طوارئ الكهرباء',
          'emergencyNumber6': 'شرطة المرور',
          'male': 'ذكر',
          'female': 'عافية ذوق',
          'fullName': 'الاسم الكامل',
          'enterFullName': 'أدخل اسمك الكامل',
          'enterYourInfo': 'الرجاء إدخال بياناتك الشخصية لإكمال انشاء حسابك',
          'enterNationalId': 'أدخل رقمك القومي',
          'nationalId': 'الرقم القومي',
          'enterBirthDate': 'اختر تاريخ ميلادك',
          'birthDate': 'تاريخ الميلاد',
          'enterGender': 'اختر جنسك',
          'addPhoto': 'اضف الصورة الشخصية',
          'changePhoto': 'تغيير الصورة',
          'addNationalID': 'اضف الرقم القومى',
          'changeNationalID': 'تغيير الرقم القومى',
          'enterPhoto': 'الرجاء إضافة صورتك الشخصية',
          'enterNationalIDPhoto': 'الرجاء إضافة صورة الرقم القومى',
          'choosePicMethod': 'الرجاء اختيار طريقة اضافة صورتك الشخصية',
          'chooseIDMethod': 'الرجاء اختيار طريقة اضافة صورة الرقم القومى',
          'pickGallery': 'اختر من المعرض',
          'capturePhoto': 'التقط صورة',
          'yes': 'نعم',
          'no': 'لا',
          'enterMedicalHistory': 'يرجى إدخال سجلك الطبي لإكمال انشاء حسابك',
          'save': 'حفظ',
          'requiredFields':
              'يرجى إكمال جميع المعلومات المميزة باللون الأحمر بشكل صحيح',
        },
        'en_US': {
          'onBoardingTitle1': 'Fast ambulance requests',
          'onBoardingTitle2': 'Customer Service',
          'onBoardingTitle3': 'Any Location',
          'onBoardingSubTitle1': 'We make every second count',
          'onBoardingSubTitle2': '24/7 available customer service',
          'onBoardingSubTitle3': 'Wherever you are, we are here for you',
          'welcome': 'Welcome',
          'welcomeTitle': 'Login or create an account',
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
          'lang': 'Language',
          'logout': 'Logout',
          'logoutConfirm': 'Are you sure you want to logout?',
          'qrCode': 'Qr code',
          'qrCodeEnter': 'Add using qr code',
          'normalRequest': 'Normal Request',
          'sosRequest': 'SOS Request',
          'services': 'Services',
          'recentRequests': 'Recent requests',
          'firstAidTips': 'First aid tips',
          'firstAid': 'First Aid',
          'emergencyNumbers': 'Emergency Numbers',
          'viewAll': 'See All',
          'payment': 'Payment',
          'back': 'Back',
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
          'firstAidTips1': 'Rapid assessment for patient',
          'firstAidTips2': 'Cardiopulmonary Resuscitation',
          'firstAidTips3': 'Choking',
          'firstAidTips4': 'Blood Sugar',
          'firstAidTips5': 'Heart Attacks',
          'firstAidTips6': 'Asthma attacks',
          'firstAidTips7': 'Cerebrovascular Stroke',
          'firstAidTips8': 'Epilepsy',
          'firstAidTips9': 'Severe Wound Bleeding',
          'firstAidTips10': 'Nosebleed',
          'firstAidTips11': 'Fractures and dislocations',
          'firstAidTips12': 'Burns',
          'firstAidTips13': 'Drowning',
          'firstAidTips14': 'Poisoning',
          'firstAidTips15': 'Emergency awareness',
          'firstAidTips16': 'Heat exhaustion',
          'firstAidTips17': 'Heat strokes',
          'emergencyNumber1': 'Ambulance',
          'emergencyNumber2': 'Police',
          'emergencyNumber3': 'Firefighting',
          'emergencyNumber4': 'Gas emergency',
          'emergencyNumber5': 'Electricity emergency',
          'emergencyNumber6': 'Traffic police',
          'male': 'Male',
          'female': 'Female',
          'fullName': 'Full Name',
          'enterFullName': 'Enter your Full Name',
          'enterYourInfo':
              'Please enter your personal information to complete your account registration',
          'enterNationalId': 'Enter your National ID',
          'nationalId': 'National ID',
          'enterBirthDate': 'Choose your Birth Date',
          'birthDate': 'Birth Date',
          'enterGender': 'Choose your Gender',
          'enterPhoto': 'Please add your Photo',
          'enterNationalIDPhoto': 'Please add your National ID Photo',
          'addPhoto': 'Add Photo',
          'changePhoto': 'Change Photo',
          'addNationalID': 'Add National ID',
          'changeNationalID': 'Change National ID',
          'choosePicMethod': 'Please choose a method to add your photo',
          'chooseIDMethod': 'Please choose a method to add your National ID',
          'pickGallery': 'Pick from gallery',
          'capturePhoto': 'Capture a photo',
          'yes': 'Yes',
          'no': 'No',
          'enterMedicalHistory':
              'Please enter your Medical History to complete your account registration',
          'save': 'Save',
          'requiredFields':
              'Please provide all of the information highlighted in red correctly',
        },
      };
}
