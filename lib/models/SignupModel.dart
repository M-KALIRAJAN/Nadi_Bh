
class SignupModel {
  final String accountType;
  final String fullName;
  final String mobileNumber;
  final String email;
  final String gender;
  final String password;


  SignupModel({
    required this.accountType,
    required this.fullName,
    required this.mobileNumber,
    required this.email,
    required this.gender,
    required this.password,

  });

  Map<String, dynamic> toJson() => {
        "accountType": accountType,
        "fullName": fullName,
        "mobileNumber": mobileNumber,
        "email": email,
        "gender": gender,
        "password": password,
     
      };
}
