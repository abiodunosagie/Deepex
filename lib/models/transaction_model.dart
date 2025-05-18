enum TransactionType { credit, debit }

enum TransactionStatus { completed, pending, failed }

enum TransactionCategory {
  airtime,
  data,
  electricity,
  giftCard,
  bankTransfer,
  deposit,
  withdrawal,
  utility
}

class TransactionModel {
  final String id;
  final TransactionType type;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionStatus status;
  final TransactionCategory category;
  final String? reference;
  final String? recipientName;
  final String? recipientAccount;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
    required this.status,
    required this.category,
    this.reference,
    this.recipientName,
    this.recipientAccount,
  });

  // Factory constructor to create transaction from JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      type: TransactionType.values.byName(json['type']),
      amount: json['amount'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      status: TransactionStatus.values.byName(json['status']),
      category: TransactionCategory.values.byName(json['category']),
      reference: json['reference'],
      recipientName: json['recipientName'],
      recipientAccount: json['recipientAccount'],
    );
  }

  // Convert transaction to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'status': status.name,
      'category': category.name,
      'reference': reference,
      'recipientName': recipientName,
      'recipientAccount': recipientAccount,
    };
  }
}
