class GiftCardModel {
  final String cardType;
  final double value;

  GiftCardModel({required this.cardType, required this.value});

  factory GiftCardModel.fromJson(Map<String, dynamic> json) {
    return GiftCardModel(
      cardType: json['cardType'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardType': cardType,
      'value': value,
    };
  }
}
