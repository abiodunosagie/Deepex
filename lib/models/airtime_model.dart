class AirtimeModel {
  final String provider;
  final double amount;

  AirtimeModel({required this.provider, required this.amount});

  factory AirtimeModel.fromJson(Map<String, dynamic> json) {
    return AirtimeModel(
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
