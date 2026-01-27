class UserdashboardModel {
  final String name;
  final int points;
  final String account;
  final String image; 

  UserdashboardModel({
    required this.name,
    required this.account,
    required this.points,
    required this.image,
  });

  factory UserdashboardModel.fromJson(Map<String, dynamic> json) {
    return UserdashboardModel(
      name: json['name'] ?? '',
      account: json['account'] ?? '',
      image: json['image'] ?? '', 
      points: json['points'] is int
          ? json['points']
          : int.tryParse(json['points']?.toString() ?? '') ?? 0,
    );
  }
}
