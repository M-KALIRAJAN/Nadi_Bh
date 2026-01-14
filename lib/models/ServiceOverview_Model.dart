class ServiceoverviewModel {
  final int serviceCompletedCount;
  final int servicePendingCount;
  final int serviceProgressCount;

  ServiceoverviewModel({
    required this.serviceCompletedCount,
    required this.servicePendingCount,
    required this.serviceProgressCount,
  });

  factory ServiceoverviewModel.fromJson(Map<String, dynamic> json) {
    return ServiceoverviewModel(
      serviceCompletedCount: json["serviceCompletedCount"] ?? 0,
      servicePendingCount: json["servicePendingCount"] ?? 0,
      serviceProgressCount: json["serviceProgressCount"] ?? 0,
    );
  }
}
