class UserInfoSave {
  final String name;
  final String email;
  final String nationalId;
  final DateTime birthDate;
  final String gender;
  UserInfoSave({
    required this.name,
    required this.email,
    required this.nationalId,
    required this.birthDate,
    required this.gender,
  });
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'nationalId': nationalId,
        'birthdate': birthDate,
        'gender': gender,
      };
}
