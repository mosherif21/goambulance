import 'package:get/get.dart';

class Languages extends Translations {
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
          'ok': 'حسنا',
          'loginWithGoogle': 'اكمل عن طريق جوجل',
          'loginWithFacebook': 'اكمل عن طريق فيسبوك',
          'loginWithMobile': 'اكمل برقم الهاتف',
          'emailLabel': 'البريد الالكترونى',
          'emailHintLabel': 'ادخل بريدك الالكترونى',
          'passwordLabel': 'كلمة المرور',
          'passwordHintLabel': 'ادخل كلمة المرور',
          'forgotPassword': 'لا تتذكر كلمة المرور؟',
          'or': 'او',
          'noEmailAccount':
              'ليس لديك حساب بريد الكترونى؟ انشئ حساب بريد الكترونى',
          'english': 'ENGLISH',
          'arabic': 'العربية',
          'chooseLanguage': 'اختر لغتك المفضلة',
          'chooseForgetPasswordMethod': 'اختر طريقة تغيير كلمة المرور',
          'emailReset': 'تغيير كلمة المرور عن طريق لينك البريد الكترونى',
          'numberReset': 'تغيير البريد الكترونى عن طريق كود برقم الهاتف',
          'phoneLabel': 'رقم الهاتف',
          'phoneFieldLabel': 'ادخل رقم هاتفك',
          'requestLocation': 'موقع الطلب',
          'requestLocationPinDesc': 'موقع طلبك',
          'chooseRequestHospital': 'اختر مستشفى طلبك',
          'hospitalLocationPinDesc': 'مستشفى طلبك',
          'ambulancePinDesc': 'سيارة الإسعاف الخاصة بك',
          'passwordResetLink':
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
          'failedGoogleAuth': 'تسجيل الدخول بجوجل فشل، حاول مرة اخرى',
          'failedFacebookAuth': 'تسجيل الدخول بفيسبوك فشل، حاول مرة اخرى',
          'failedAuth': 'فشل تسجيل الدخول',
          'success': 'محاولة ناجحة',
          'error': 'حدث خطا',
          'home': 'الرئيسية',
          'search': 'البحث',
          'account': 'الحساب',
          'requests': 'الطلبات',
          'help': 'المساعدة',
          'emailResetSuccess':
              'تم إرسال البريد الإلكتروني الخاص بإعادة تعيين كلمة المرور بنجاح',
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
          'deletingEmergencyContactFailed':
              'فشل حذف جهة الاتصال ، يرجى المحاولة مرة أخرى',
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
          'enableLocationService': 'الرجاء تمكين خدمة الموقع',
          'locationPermission': 'إذن الموقع',
          'locationPermissionDeniedForever':
              'تم رفض إذن المواقع إلى الأبد، يرجى تمكينه من الإعدادات',
          'cameraPermission': 'اذن الكاميرا',
          'cameraPermissionDeniedForever':
              'تم رفض إذن الكاميرا إلى الأبد، يرجى تمكينه من الإعدادات',
          'storagePermission': 'اذن الذاكرة',
          'storagePermissionDeniedForever':
              'تم رفض إذن الذاكرة إلى الأبد، يرجى تمكينه من الإعدادات',
          'callPermission': 'اذن المكالمات',
          'callPermissionDeniedForever':
              'تم رفض إذن المكالمات إلى الأبد، يرجى تمكينه من الإعدادات',
          'micPermission': 'اذن المايكروفون',
          'micPermissionDeniedForever':
              'تم رفض إذن المايكروفون إلى الأبد، يرجى تمكينه من الإعدادات',
          'contactsPermission': 'اذن جهات الاتصال',
          'contactsPermissionDeniedForever':
              'تم رفض إذن جهات الاتصال إلى الأبد، يرجى تمكينه من الإعدادات',
          'smsPermission': 'اذن الرسائل القصيرة',
          'smsPermissionDeniedForever':
              'تم رفض إذن الرسائل القصيرة إلى الأبد، يرجى تمكينه من الإعدادات',
          'enableLocationPermission': 'الرجاء تمكين اذن الموقع',
          'enableCameraPermission': 'الرجاء تمكين اذن الكاميرا',
          'enableStoragePermission': 'الرجاء تمكين اذن الذاكرة',
          'enableCallPermission': 'الرجاء تمكين اذن المكالمات',
          'enableMicPermission': 'الرجاء تمكين اذن المايكروفون',
          'enableContactsPermission': 'الرجاء تمكين اذن جهات الاتصال',
          'enableSmsPermission': 'الرجاء قبول إذن الرسائل القصيرة',
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
          'female': 'انثى',
          'fullName': 'الاسم الكامل',
          'addressNotFound': 'تعذر الحصول على العنوان',
          'enterFullName': 'أدخل اسمك بالكامل',
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
          'sendSosMessage': 'أرسل رسالة الاستغاثة',
          'save': 'حفظ',
          'requiredFields':
              'يرجى إكمال جميع المعلومات المميزة باللون الأحمر بشكل صحيح',
          'saveUserInfoError':
              'حفظ المعلومات الخاصة بك فشل، يرجى المحاولة مرة أخرى',
          'loginFailed': 'فشل تسجيل الدخول، يرجى المحاولة مرة أخرى',
          'noMedicalHistory': 'لم تتم إضافة أي أمراض أو حساسية',
          'noRequestsHistory': 'ليس لديك أي طلبات سابقة',
          'addAllergiesOrDiseases': 'اضف مرض/حساسية',
          'diseaseName': 'اسم المرض/الحساسية',
          'enterDiseaseName': 'ادخل اسم المرض/الحساسية',
          'medicineName': 'الادوية',
          'enterMedicineName': 'ادخل الادوية',
          'missingDiseaseName': 'الرجاء إدخال اسم المرض/الحساسية',
          'chooseBloodType': 'الرجاء اختيار فصيلة دمك:',
          'chooseHisBloodType': 'الرجاء اختيار فصيلة الدم:',
          'pickBloodType': 'اختر فصيلة الدم',
          'askYou': 'هل انت',
          'askHim': 'هل هو/هى',
          'askDiabetic': '@ask مريض سكر؟',
          'askHeartPatient': '@ask مريض قلب؟',
          'askHypertensivePatient': '@ask مريض ارتفاع ضغط الدم؟',
          'routeTime': 'على بعد @routeTime',
          'don\'tKnow': 'لا اعلم',
          'add': 'اضف',
          'agree': 'اوافق',
          'disagree': 'لا اوافق',
          'diseaseInfo': 'الرجاء إدخال معلومات المرض/الحساسية',
          'personalInfoShare':
              'ستتم مشاركة معلوماتك مع المستشفى في حال طلب سيارة إسعاف',
          'additionalInformation': 'معلومات إضافية',
          'enterAdditionalInformation': 'أدخل أي معلومات إضافية',
          'conditionInformation': 'حالة المريض',
          'enterConditionInformation': 'أدخل حالة المريض',
          'phoneNumberAlreadyLinked': 'رقم الهاتف هذا مرتبط بالفعل بحساب آخر',
          'phoneNumberAlreadyYourAccount': 'رقم الهاتف هذا مرتبط بالفعل بحسابك',
          'cancel': 'الغاء',
          'addingEmergencyContactFailed':
              'فشلت إضافة جهة اتصال الطوارئ ، يرجى المحاولة مرة أخرى',
          'savingSosMessageFailed':
              'فشل حفظ رسالة الاستغاثة ، يرجى المحاولة مرة أخرى',
          'sosMessageSaved': 'تم حفظ رسالة الاستغاثة بنجاح',
          'selectValue': 'اختر',
          'enterBackupPhoneNo': 'أدخل رقم هاتف احتياطي',
          'goToSettings': 'اذهب للاعدادات',
          'searchCountry': 'البحث عن البلد',
          'sosMessage': 'رسالة استغاثة',
          'noEmergencyContacts': 'لم تتم إضافة جهات اتصال للطوارئ',
          'addContact': 'اضف جهة اتصال',
          'contactName': 'اسم جهة الاتصال',
          'enterContactName': 'أدخل اسم جهة الاتصال',
          'missingEmergencyContact':
              'الرجاء إضافة جهة اتصال طوارئ لاستخدام هذه الخاصية',
          'contactNumber': 'رقم جهة الاتصال',
          'enterContactNumber': 'أدخل رقم جهة الاتصال',
          'contactInfo': 'الرجاء إدخال معلومات جهة الاتصال',
          'searchingForHospitals': 'جارى البحث عن مستشفيات',
          'noHospitalsFound': 'لم يتم العثور على مستشفيات',
          'nearHospitalsNotFound':
              'عذرا ، لم نتمكن من العثور على أي مستشفيات قريبة من مكان الطلب',
          'notAllowed': 'غير مسموح به',
          'refreshing': 'جارى التحديث',
          'refreshCompleted': 'اكتمل التحديث',
          'signOutFailed': 'فشل تسجيل الخروج ، يرجى المحاولة مرة أخرى',
          'failedGoogleLink': 'فشل ربط حساب جوجل ، يرجى المحاولة مرة أخرى',
          'successGoogleLink': 'تم ربط حساب جوجل بنجاح',
          'googleAccountInUse':
              'حساب جوجل هذا قيد الاستخدام من قبلك أو من قبل مستخدم آخر',
          'pullToRefresh': 'للتحديث اسحب للأسفل',
          'releaseToRefresh': 'حرر للتحديث',
          'enableLocationPermissionButton': 'اعطي أذن الموقع',
          'enableLocationServiceButton': 'تمكين الموقع',
          'findingLocation': 'جارى البحث عن موقعك',
          'locationNotAllowed': 'عذرا ، هذا الموقع غير مسموح به حاليا',
          'locationNotAccessed': 'لا يمكن الوصول إلى موقعك',
          'searchPlace': 'البحث عن مكان',
          'sosMessageHeader': 'الرجاء إدخال رسالة الاستغاثة التي سيتم إرسالها',
          'enterSosMessage': 'أدخل رسالة الاستغاثة',
          'loading': 'جاري تحميل...',
          'requestHere': 'اطلب هنا',
          'confirmRequest': 'تاكيد الطلب',
          'cancelRequest': 'الغاء الطلب',
          'accountDetailSavedSuccess': 'تم حفظ معلومات الحساب بنجاح',
          'medicalHistorySavedSuccess': 'تم حفظ السجل الطبي بنجاح',
          'useMobileToThisFeature':
              'يرجى استخدام تطبيق الهاتف المحمول لاستخدام هذه الخاصية',
          'useMobileToRegister':
              'الرجاء استخدام تطبيق الهاتف لتسجيل البيانات الخاصة بك',
          'enterRequestInfo': 'يرجى تعبئة بيانات طلب الإسعاف',
          'accountTitle1': 'بيانات المستخدم',
          'accountTitle2': 'العناوين المسجلة',
          'accountTitle3': 'السجل الطبي',
          'accountTitle4': 'تغيير رقم الهاتف',
          'sendSosMessageSuccess': 'تم إرسال رسالة الاستغاثة بنجاح',
          'savedEmergencyContacts': 'جهات اتصال الطوارئ المحفوظة',
          'medicalHistorySavedError':
              'فشل حفظ السجل الطبي ، يرجى المحاولة مرة أخرى',
          'sendingSosMessageFailed':
              'فشل إرسال رسالة الاستغاثة ، يرجى المحاولة مرة أخرى',
          'addedDiseases': 'الأمراض / الحساسيات المضافة',
          'editMedicalHistory': 'يمكنك تعديل سجلك الطبي هنا',
          'phoneChangeSuccess': 'تم تغيير رقم الهاتف بنجاح',
          'egp': 'جنيها',
          'forMe': 'لي',
          'pullToLoad': 'لتحميل المزيد اسحب للأسفل',
          'releaseToLoad': 'حرر لتحميل المزيد',
          'loadingCompleted': 'اكتمل التحميل',
          'noMoreHospitals': 'لا يوجد مزيد من المستشفيات',
          'loadingFailed': 'فشل التحميل، انقر على إعادة المحاولة',
          'avgPrice': 'متوسط السعر',
          'someoneElse': 'لشخص اخر',
          'requestFor': 'لمن طلب سيارة الإسعاف هذا؟',
          'editUserInfo': 'يمكنك تعديل بياناتك من هنا',
          'linkGoogleAccount': 'ربط حساب جوجل',
          'linkFacebookAccount': 'ربط حساب فيسبوك',
          'accountTitle5': 'ربط حساب بريد الكتروني و كلمة مرور',
          'accountTitle6': 'ارسال رابط تغيير كلمة المرور',
          'verify': 'توثيق البريد الالكتروني ',
          'tryAgain': 'حاول مرة أخرى',
          'aboutUsTitle1': 'شروط الاستخدام',
          'aboutUsTitle2': 'سياسة الخصوصية',
          'aboutUsTitle3': 'الاسئلة المتكررة',
          'aboutUsTitle4': 'موقعنا',
          'changeGoogleAccount': 'تغيير حساب جوجل',
          'cancelRequestConfirm': 'هل أنت متأكد أنك تريد إلغاء الطلب؟',
        },
        'en_US': {
          'onBoardingTitle1': 'Fast ambulance requests',
          'onBoardingTitle2': 'Customer Service',
          'onBoardingTitle3': 'Any Location',
          'onBoardingSubTitle1': 'We make every second count',
          'onBoardingSubTitle2': '24/7 available customer service',
          'onBoardingSubTitle3': 'Wherever you are, we are here for you',
          'welcome': 'Welcome',
          'changeGoogleAccount': 'Change Google Account',
          'noMoreHospitals': 'No more hospitals',
          'loadingFailed': 'Loading Failed, Click retry',
          'welcomeTitle': 'Login or create an account',
          'loginTextTitle': 'LOGIN',
          'registerTextTitle': 'REGISTER',
          'skipLabel': 'Skip',
          'successGoogleLink': 'Google account was linked successfully',
          'notAvailableErrorTitle': 'Not Currently Available',
          'notAvailableErrorSubTitle': 'We are working on it....',
          'noConnectionAlertTitle': 'No Connection',
          'noConnectionAlertContent': 'Please check your internet connectivity',
          'ok': 'OK',
          'addContact': 'Add contact',
          'loginWithGoogle': 'CONTINUE WITH GOOGLE',
          'loginWithFacebook': 'CONTINUE WITH FACEBOOK',
          'loginWithMobile': 'CONTINUE WITH PHONE NUMBER',
          'emailLabel': 'E-Mail',
          'sosMessageSaved': 'SOS message saved successfully',
          'medicalHistorySavedSuccess': 'Medical history saved successfully',
          'medicalHistorySavedError':
              'Medical history save failed, please try again',
          'emailHintLabel': 'Enter your E-Mail',
          'tryAgain': 'Try again',
          'passwordLabel': 'Password',
          'passwordHintLabel': 'Enter your Password',
          'missingEmergencyContact':
              'Please add an emergency contact to use this feature',
          'sendSosMessage': 'Send SOS message',
          'sendSosMessageSuccess': 'SOS message sent successfully',
          'forgotPassword': 'Forgot Password?',
          'addedDiseases': 'Added diseases/allergies',
          'savedEmergencyContacts': 'Saved emergency contacts',
          'or': 'OR',
          'noEmailAccount': 'Don\'t have an email account? Register with email',
          'english': 'ENGLISH',
          'arabic': 'العربية',
          'chooseLanguage': 'Choose your preferred language',
          'chooseForgetPasswordMethod':
              'Choose a method to reset your password',
          'emailReset': 'Reset password via E-Mail Link',
          'numberReset': 'Reset password via Phone OTP Verification',
          'phoneLabel': 'Phone number',
          'addingEmergencyContactFailed':
              'Adding emergency contact failed, please try again',
          'savingSosMessageFailed': 'SOS message save failed, please try again',
          'sendingSosMessageFailed':
              'Sending SOS message failed, please try again',
          'deletingEmergencyContactFailed':
              'Contact deletion failed, please try again',
          'phoneFieldLabel': 'Enter your Phone Number',
          'passwordResetLink':
              'Enter your E-Mail to get the password reset link',
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
          'failedGoogleLink': 'Google account Link failed, Please try again',
          'googleAccountInUse':
              'This google account is already in use by you or another user',
          'failedFacebookAuth':
              'Facebook authentication failed, Please try again',
          'failedAuth': 'Authentication failed',
          'success': 'Success',
          'error': 'Error',
          'home': 'Home',
          'search': 'Search',
          'account': 'Account',
          'requests': 'Requests',
          'help': 'Help',
          'emailResetSuccess': 'Reset password email sent successfully',
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
              'Please enable location service to use this feature',
          'acceptLocationPermission':
              'Please enable location service to use this feature',
          'locationPermission': 'Location permission',
          'locationPermissionDeniedForever':
              'Locations permission denied forever please enable it from the settings',
          'cameraPermission': 'Camera permission',
          'cameraPermissionDeniedForever':
              'Camera permission denied forever please enable it from the settings',
          'storagePermission': 'Storage permission',
          'storagePermissionDeniedForever':
              'Storage permission denied forever please enable it from the settings',
          'callPermission': 'Call permission',
          'callPermissionDeniedForever':
              'Call permission denied forever please enable it from the settings',
          'micPermission': 'Microphone permission',
          'micPermissionDeniedForever':
              'Microphone permission denied forever please enable it from the settings',
          'contactsPermission': 'Contacts permission',
          'contactsPermissionDeniedForever':
              'Contacts permission denied forever please enable it from the settings',
          'enableLocationPermission': 'Please accept location permission',
          'enableCameraPermission': 'Please accept camera permission',
          'enableStoragePermission': 'Please accept storage permission',
          'accountTitle4': 'Change phone number',
          'enableCallPermission': 'Please accept call permission',
          'enableMicPermission': 'Please accept microphone permission',
          'enableContactsPermission': 'Please accept contacts permission',
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
          'accountDetailSavedSuccess': 'Account information saved successfully',
          'phoneChangeSuccess': 'Phone number changed successfully',
          'pullToRefresh': 'Pull down to refresh',
          'releaseToRefresh': 'Release to refresh',
          'refreshing': 'Refreshing',
          'refreshCompleted': 'Refresh completed',
          'pullToLoad': 'Pull up to load more',
          'releaseToLoad': 'Release to load more',
          'loadingCompleted': 'Loading completed',
          'fullName': 'Full Name',
          'enterSosMessage': 'Enter sos message',
          'signOutFailed': 'Sign out failed, please try again',
          'nearHospitalsNotFound':
              'Sorry, we couldn\'t find any hospitals near the request location',
          'enterFullName': 'Enter your Full Name',
          'addressNotFound': 'Couldn\'t get address',
          'enterYourInfo':
              'Please enter your personal information to complete your account registration',
          'enterNationalId': 'Enter your National ID',
          'nationalId': 'National ID',
          'enterBirthDate': 'Choose your Birth Date',
          'birthDate': 'Birth Date',
          'enterGender': 'Choose your Gender',
          'hospitalLocationPinDesc': 'Your request\'s hospital',
          'enterPhoto': 'Please add your Photo',
          'enterNationalIDPhoto': 'Please add your National ID Photo',
          'addPhoto': 'Add Photo',
          'changePhoto': 'Change Photo',
          'addNationalID': 'Add National ID',
          'changeNationalID': 'Change National ID',
          'choosePicMethod': 'Please choose a method to add your photo',
          'chooseIDMethod': 'Please choose a method to add your National ID',
          'selectValue': 'Select',
          'pickGallery': 'Pick from gallery',
          'capturePhoto': 'Capture a photo',
          'smsPermission': 'SMS permission',
          'smsPermissionDeniedForever':
              'SMS permission denied forever please enable it from the settings',
          'enableSmsPermission': 'Please accept SMS permission',
          'yes': 'Yes',
          'no': 'No',
          'don\'tKnow': 'Don\'t know',
          'contactName': 'Contact name',
          'enterContactName': 'Enter contact name',
          'contactNumber': 'Contact\'s number',
          'enterContactNumber': 'Enter contact\'s number',
          'searchingForHospitals': 'Searching for hospitals',
          'enterMedicalHistory':
              'Please enter your medical history to complete your account registration',
          'editMedicalHistory': 'You can edit your medical history here',
          'save': 'Save',
          'requiredFields':
              'Please provide all of the information highlighted in red correctly',
          'saveUserInfoError':
              'Failed to save your information, please try again',
          'loginFailed': 'Login failed, please try again',
          'noMedicalHistory': 'No diseases or allergies added',
          'noEmergencyContacts': 'No emergency contacts added',
          'sosMessageHeader': 'Please enter the sos message that will be sent',
          'noRequestsHistory': 'You don\'t have any previous requests',
          'addAllergiesOrDiseases': 'Add Disease/Allergy',
          'diseaseName': 'Disease/Allergy name',
          'enterDiseaseName': 'Enter Disease/Allergy name',
          'medicineName': 'Medicine/s',
          'enterMedicineName': 'Enter medicine/s',
          'missingDiseaseName': 'Please enter disease/allergy name',
          'chooseBloodType': 'Please choose your blood type',
          'pickBloodType': 'Select blood type',
          'askDiabetic': '@ask diabetic?',
          'askHeartPatient': '@ask a heart patient?',
          'askHypertensivePatient': '@ask a hypertensive patient?',
          'routeTime': '@routeTime away',
          'chooseHisBloodType': 'Please choose his/hers blood type',
          'askYou': 'Are you',
          'askHim': 'Is he/she',
          'add': 'Add',
          'agree': 'I Agree',
          'disagree': 'Disagree',
          'noHospitalsFound': 'No hospitals found',
          'diseaseInfo': 'Please enter the disease/allergy information',
          'contactInfo': 'Please enter the contact\'s information',
          'personalInfoShare':
              'Your information will be shared with the hospital in case you request an ambulance',
          'cancelRequestConfirm':
              'Are you sure you want to cancel the request?',
          'additionalInformation': 'Additional information',
          'enterAdditionalInformation': 'Enter any additional information',
          'enterBackupPhoneNo': 'Enter a backup phone number',
          'conditionInformation': 'Patient condition',
          'enterConditionInformation': 'Enter the patient condition',
          'phoneNumberAlreadyLinked':
              'This Phone number is already linked with another account',
          'phoneNumberAlreadyYourAccount':
              'This Phone number is already linked with your account',
          'cancel': 'Cancel',
          'goToSettings': 'Go to settings',
          'searchCountry': 'Search for country',
          'sosMessage': 'SOS Message',
          'enableLocationPermissionButton': 'Grant location permission',
          'enableLocationServiceButton': 'Enable Location',
          'findingLocation': 'Finding your location',
          'searchPlace': 'Search for a place',
          'requestHere': 'Request here',
          'confirmRequest': 'Confirm request',
          'cancelRequest': 'Cancel request',
          'loading': 'Loading...',
          'notAllowed': 'Not allowed',
          'requestLocation': 'Request Location',
          'requestLocationPinDesc': 'Your request location',
          'chooseRequestHospital': 'Choose your request\'s hospital',
          'ambulancePinDesc': 'Your ambulance',
          'locationNotAllowed': 'Sorry, this location is currently not allowed',
          'locationNotAccessed': 'Your location can\'t be accessed',
          'useMobileToThisFeature':
              'Please use the mobile app to use this feature',
          'useMobileToRegister':
              'Please use the mobile application to register your data',
          'enterRequestInfo': 'Please fill the ambulance request information',
          'accountTitle1': 'Account Details',
          'accountTitle2': 'Saved Addresses',
          'accountTitle3': 'Medical Record',
          'forMe': 'For me',
          'egp': 'EGP',
          'someoneElse': 'Someone else',
          'avgPrice': 'Average price',
          'requestFor': 'Who is this ambulance request for?',
          'editUserInfo': 'You can edit your account details here',
          'linkGoogleAccount': 'Link Google Account',
          'linkFacebookAccount': 'Link Facebook Account',
          'accountTitle5': 'Link Email and Password Account',
          'accountTitle6': 'Send Reset Password Link',
          'verify': 'Verify Email',
          'aboutUsTitle1': 'Terms of use',
          'aboutUsTitle2': 'Privacy Policy',
          'aboutUsTitle3': 'FAQ',
          'aboutUsTitle4': 'Our Website',
        },
      };
}
