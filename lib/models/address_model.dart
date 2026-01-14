class AddressModel {
  final String city;
  final String street;
  final String aptNo;
  final String building;
   final String floor;
   final String rode;
    final String block;

  AddressModel({
    required this.aptNo,
    required this.street,
    required this.city,
    required this.building,
      required this.floor,
      required this.rode,
       required this.block
  });

  Map<String, dynamic> toJson() => {
        "city": city,
        "street": street,
        "aptNo": aptNo,
        "building": building,
          "floor": floor,
          "rode":rode
      };
}
