class UserdashboardModel {
  final String name;
  final int points;
  final String account;

  UserdashboardModel({
    required this.name,
    required this.account,
    required this.points,
  });

factory UserdashboardModel.fromJson(Map<String, dynamic> json) {
  return UserdashboardModel(
    name: json['name'] ?? '',
    account: json['account'] ?? '',
    points: json['points'] is int
        ? json['points']
        : int.tryParse(json['points'].toString()) ?? 0,
  );
}


  
}
