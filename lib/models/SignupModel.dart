class SignupModel {
  final String accountType;
  final String firstName;
  final String secondName;
  final String thirdName;
  final String fourthName;
  final String mobileNumber;
  final String email;
  final String gender;
  final String password;

  SignupModel({
    required this.accountType,
    required this.firstName,
    required this.secondName,
    required this.thirdName,
    required this.fourthName,
    required this.mobileNumber,
    required this.email,
    required this.gender,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "accountType": accountType,
        "firstName": firstName,
        "secondName": secondName,
        "thirdName": thirdName,
        "fourthName": fourthName,
        "mobileNumber": mobileNumber,
        "email": email,
        "gender": gender,
        "password": password,
      };
}