import '../../../general/general_functions.dart';

String getFirstAidTipImage(int firstAidNumber) =>
    'assets/images/firstAidTipImage$firstAidNumber.jpg';

String getEmergencyNumberImage(int firstAidNumber) =>
    'assets/images/emergencyNumberImage$firstAidNumber.png';

String getFirstAidDetailsPath(int firstAidNumber) => isLangEnglish()
    ? 'assets/images/firstAidTipDetailsEng$firstAidNumber.jpg'
    : 'assets/images/firstAidTipDetailsAr$firstAidNumber.jpg';

List<String> emergencyNumbers = ['123', '122', '180', '129', '121', '128'];
