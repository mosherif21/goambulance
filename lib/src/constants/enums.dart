//--------------------- ENUMS -------------------//

enum Gender { male, female }

enum Language { english, arabic }

enum InputType { email, phone, text, numbers }

enum ScreenSize { small, medium, large }

enum AuthType { emailLogin, emailRegister, facebook, google, phone }

enum UserType { driver, medic, patient }

enum FunctionStatus { success, failure }

enum SnackBarType { success, error, info, warning }

enum MarkerWindowType { requestLocation, ambulanceLocation, hospitalLocation }

enum CriticalUserStatus {
  non,
  criticalUserAccepted,
  criticalUserDenied,
  criticalUserPending,
}

enum RequestStatus {
  non,
  pending,
  accepted,
  assigned,
  ongoing,
  completed,
  canceled,
}
