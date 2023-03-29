import 'package:goambulance/src/constants/app_init_constants.dart';

String getFirstAidTipImage(int firstAidNumber) =>
    'assets/images/firstAidTipImage$firstAidNumber.jpg';

String getFirstAidDetailsPath(Language language, int firstAidNumber) =>
    language == Language.english
        ? 'assets/images/firstAidTipDetailsEng$firstAidNumber.jpg'
        : 'assets/images/firstAidTipDetailsAr$firstAidNumber.jpg';
