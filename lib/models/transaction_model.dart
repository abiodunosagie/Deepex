// lib/models/transaction_model.dart (Updated with deposit category)


enum TransactionType {
  credit,
  debit,
}

enum TransactionStatus {
  completed,
  pending,
  failed,
}

enum TransactionCategory {
  airtime,
  data,
  utility,
  electricity,
  bankTransfer,
  giftCard,
  deposit, // Added deposit category
}

class TransactionModel {
  final String id;
  final TransactionType type;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionStatus status;
  final TransactionCategory category;
  final String reference;
  final String? recipientInfo;
  final String? senderInfo;
  final String? failureReason;
  final Map<String, dynamic>? additionalInfo;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
    required this.status,
    required this.category,
    this.reference = '',
    this.recipientInfo,
    this.senderInfo,
    this.failureReason,
    this.additionalInfo,
  });
}
