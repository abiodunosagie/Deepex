// lib/models/data_plan_model.dart
class DataPlanModel {
  final String id;
  final String provider; // MTN, GLO, AIRTEL, 9MOBILE
  final String name;
  final String description;
  final double price;
  final String duration; // 1 Day, 7 Days, 30 Days, etc.
  final String dataAmount; // 1GB, 2GB, etc.
  final bool isPopular;

  DataPlanModel({
    required this.id,
    required this.provider,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.dataAmount,
    this.isPopular = false,
  });
}
