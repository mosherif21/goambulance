import 'package:get/get_utils/src/get_utils/get_utils.dart';

String? validateTextOnly(String? value) {
  if (value == null || value.isEmpty) {
    return 'Input required';
  }
  final isCharactersOnly = RegExp(r'^[a-zA-Z\u0600-\u06FF ]+$').hasMatch(value);
  if (!isCharactersOnly) {
    return 'Input must contain only Arabic, English characters, or spaces';
  }
  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number is required';
  }
  final isPhoneValid = RegExp(r'^\+?[0-9]{11}$').hasMatch(value);
  if (!isPhoneValid) {
    return 'Invalid phone number format';
  }
  if (value.length != 11) {
    return 'Phone number must be exactly 11 digits long';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  if (!value.contains(new RegExp(r'[A-Z]'))) {
    return 'Password must contain at least one uppercase letter';
  }
  if (!value.contains(new RegExp(r'[a-z]'))) {
    return 'Password must contain at least one lowercase letter';
  }
  if (!value.contains(new RegExp(r'[0-9]'))) {
    return 'Password must contain at least one number';
  }
  if (!value.contains(new RegExp(r'[!@#\$&*~]'))) {
    return 'Password must contain at least one special character (!,@,#,\$,&,*,~)';
  }
  return null;
}

String? validateNationalId(String? value) {
  if (value == null || value.isEmpty) {
    return 'National ID is required';
  } else if (!GetUtils.isNumericOnly(value)) {
    return 'National ID must contain only numbers';
  } else if (value.length != 14) {
    return 'National ID must be 10 digits';
  }
  return null;
}

String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'Email is required';
  } else if (!GetUtils.isEmail(email)) {
    return 'Please enter a valid email';
  }
  return null;
}
