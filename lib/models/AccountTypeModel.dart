class AccountTypeModel {
  final String id;
  final String name;
  final String type;

  AccountTypeModel({
    required this.id,
    required this.name,
    required this.type,
  });

  factory AccountTypeModel.fromJson(Map<String, dynamic> json) {
    return AccountTypeModel(
      id: json['_id'],
      name: json['name'],
      type: json['type'], // IA or FA
    );
  }
}
