class ElectricityBillModel {
  final String provider;
  final double amount;

  ElectricityBillModel({required this.provider, required this.amount});

  factory ElectricityBillModel.fromJson(Map<String, dynamic> json) {
    return ElectricityBillModel(
      provider: json['provider'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'amount': amount,
    };
  }
}
