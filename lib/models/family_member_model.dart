

class FamilyMemberModel {
  final String fullName;
  final String mobileNumber;
  final String email;
  final String gender;

  final String relation;
  final String familyCount;


  FamilyMemberModel({
    required this.relation,

    required this.fullName,
    required this.mobileNumber,
    required this.email,
    required this.gender,

    required this.familyCount,
  });

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "mobileNumber": mobileNumber,
    "email": email,
    "gender": gender,
    "relation": relation,
    "familyCount": familyCount,
   
  };
}
