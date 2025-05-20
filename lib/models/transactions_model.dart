// lib/models/transaction_model.dart


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

  TransactionModel({
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

  // Convert to a Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString(),
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'status': status.toString(),
      'category': category.toString(),
      'reference': reference,
      'recipientInfo': recipientInfo,
      'senderInfo': senderInfo,
      'failureReason': failureReason,
      'additionalInfo': additionalInfo,
    };
  }

  // Create a Transaction from a Map
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: _getTransactionType(map['type']),
      amount: map['amount'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      status: _getTransactionStatus(map['status']),
      category: _getTransactionCategory(map['category']),
      reference: map['reference'] ?? '',
      recipientInfo: map['recipientInfo'],
      senderInfo: map['senderInfo'],
      failureReason: map['failureReason'],
      additionalInfo: map['additionalInfo'],
    );
  }

  // Helper methods to convert string to enum
  static TransactionType _getTransactionType(String type) {
    return TransactionType.values.firstWhere(
      (e) => e.toString() == type,
      orElse: () => TransactionType.debit,
    );
  }

  static TransactionStatus _getTransactionStatus(String status) {
    return TransactionStatus.values.firstWhere(
      (e) => e.toString() == status,
      orElse: () => TransactionStatus.pending,
    );
  }

  static TransactionCategory _getTransactionCategory(String category) {
    return TransactionCategory.values.firstWhere(
      (e) => e.toString() == category,
      orElse: () => TransactionCategory.utility,
    );
  }

  // Create a copy of this transaction with optional updated fields
  TransactionModel copyWith({
    String? id,
    TransactionType? type,
    double? amount,
    String? description,
    DateTime? date,
    TransactionStatus? status,
    TransactionCategory? category,
    String? reference,
    String? recipientInfo,
    String? senderInfo,
    String? failureReason,
    Map<String, dynamic>? additionalInfo,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      status: status ?? this.status,
      category: category ?? this.category,
      reference: reference ?? this.reference,
      recipientInfo: recipientInfo ?? this.recipientInfo,
      senderInfo: senderInfo ?? this.senderInfo,
      failureReason: failureReason ?? this.failureReason,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }
}
