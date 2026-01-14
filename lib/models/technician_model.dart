class TechnicianModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String image;

  TechnicianModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.image,
  });

  factory TechnicianModel.fromJson(Map<String, dynamic> json) {
    return TechnicianModel(
      id: json["_id"] ?? "",
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      email: json["email"] ?? "",
      mobile: json["mobile"].toString(),
      image: json["image"] ?? "",
    );
  }
}
