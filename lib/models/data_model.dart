class DataModel {
  final String provider;
  final double amount;

  DataModel({required this.provider, required this.amount});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
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
