// lib/models/airtime_model.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AirtimeModel {
  final String network;
  final String phoneNumber;
  final String formattedNumber;
  final double amount;
  final DateTime timestamp;

  AirtimeModel({
    required this.network,
    required this.phoneNumber,
    required this.formattedNumber,
    required this.amount,
    required this.timestamp,
  });

  factory AirtimeModel.fromJson(Map<String, dynamic> json) {
    return AirtimeModel(
      network: json['network'],
      phoneNumber: json['phoneNumber'],
      formattedNumber: json['formattedNumber'],
      amount: json['amount'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'network': network,
      'phoneNumber': phoneNumber,
      'formattedNumber': formattedNumber,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Service to manage airtime purchase history and recent numbers
class AirtimeService {
  static const String _recentNumbersKey = 'recent_airtime_numbers';
  static const String _recentPurchasesKey = 'recent_airtime_purchases';
  static const int _maxRecentItems = 5;

  /// Load recently used phone numbers
  static Future<List<String>> getRecentNumbers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recentNumbersJson = prefs.getString(_recentNumbersKey);
      if (recentNumbersJson != null) {
        final List<dynamic> decoded = jsonDecode(recentNumbersJson);
        return decoded.cast<String>();
      }
    } catch (e) {
      print('Error loading recent numbers: $e');
    }
    return [];
  }

  /// Save a phone number to recent numbers
  static Future<void> saveRecentNumber(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;

    try {
      // Format number consistently for storage
      final formattedNumber = _formatNumberForStorage(phoneNumber);

      // Get existing numbers
      List<String> recentNumbers = await getRecentNumbers();

      // Remove if already exists and add to beginning
      recentNumbers.removeWhere((number) => number == formattedNumber);
      recentNumbers.insert(0, formattedNumber);

      // Keep only the most recent items
      if (recentNumbers.length > _maxRecentItems) {
        recentNumbers = recentNumbers.sublist(0, _maxRecentItems);
      }

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_recentNumbersKey, jsonEncode(recentNumbers));
    } catch (e) {
      print('Error saving recent number: $e');
    }
  }

  /// Load recent airtime purchases
  static Future<List<AirtimeModel>> getRecentPurchases() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recentPurchasesJson = prefs.getString(_recentPurchasesKey);
      if (recentPurchasesJson != null) {
        final List<dynamic> decoded = jsonDecode(recentPurchasesJson);
        return decoded.map((item) => AirtimeModel.fromJson(item)).toList();
      }
    } catch (e) {
      print('Error loading recent purchases: $e');
    }
    return [];
  }

  /// Save an airtime purchase
  static Future<void> savePurchase(AirtimeModel purchase) async {
    try {
      // Get existing purchases
      List<AirtimeModel> recentPurchases = await getRecentPurchases();

      // Add new purchase to beginning
      recentPurchases.insert(0, purchase);

      // Keep only the most recent items
      if (recentPurchases.length > _maxRecentItems) {
        recentPurchases = recentPurchases.sublist(0, _maxRecentItems);
      }

      // Convert to JSON
      final List<Map<String, dynamic>> purchasesJson =
          recentPurchases.map((item) => item.toJson()).toList();

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_recentPurchasesKey, jsonEncode(purchasesJson));
    } catch (e) {
      print('Error saving purchase: $e');
    }
  }

  /// Format phone number for consistent storage
  static String _formatNumberForStorage(String number) {
    // Remove all non-digit characters
    final digitsOnly = number.replaceAll(RegExp(r'[^\d]'), '');

    // Ensure the number starts with the country code
    if (digitsOnly.startsWith('0')) {
      return '+234${digitsOnly.substring(1)}';
    } else if (digitsOnly.startsWith('234')) {
      return '+$digitsOnly';
    } else if (!digitsOnly.startsWith('+')) {
      return '+234$digitsOnly';
    }

    return number;
  }

  /// Format phone number for display (e.g. +234 803 123 4567)
  static String formatPhoneNumber(String number) {
    // Remove all non-digit characters
    final digitsOnly = number.replaceAll(RegExp(r'[^\d+]'), '');

    // Format based on Nigerian phone number pattern
    if (digitsOnly.startsWith('0') && digitsOnly.length >= 11) {
      // 0803 123 4567 format
      return '${digitsOnly.substring(0, 4)} ${digitsOnly.substring(4, 7)} ${digitsOnly.substring(7, 11)}';
    } else if (digitsOnly.startsWith('+234') && digitsOnly.length >= 13) {
      // +234 803 123 4567 format
      return '+234 ${digitsOnly.substring(4, 7)} ${digitsOnly.substring(7, 10)} ${digitsOnly.substring(10, 14)}';
    } else if (digitsOnly.startsWith('234') && digitsOnly.length >= 12) {
      // +234 803 123 4567 format
      return '+234 ${digitsOnly.substring(3, 6)} ${digitsOnly.substring(6, 9)} ${digitsOnly.substring(9, 13)}';
    } else if (digitsOnly.length >= 10) {
      // Try to format as 803 123 4567
      return '${digitsOnly.substring(0, 3)} ${digitsOnly.substring(3, 6)} ${digitsOnly.substring(6)}';
    }

    // Return as is if it doesn't match expected patterns
    return number;
  }

  /// Detect network provider from Nigerian phone number
  static String detectNetworkProvider(String number) {
    // Remove all non-digit characters
    final digitsOnly = number.replaceAll(RegExp(r'[^\d]'), '');

    // Check if we have enough digits to detect network
    if (digitsOnly.length < 4) return '';

    // Get the prefix - handles both 0803... and +234803... formats
    String prefix;
    if (digitsOnly.startsWith('0')) {
      prefix = digitsOnly.substring(1, 4);
    } else if (digitsOnly.startsWith('234')) {
      prefix = digitsOnly.substring(3, 6);
    } else {
      prefix = digitsOnly.substring(0, 3);
    }

    // Match prefix to network
    if (['803', '806', '703', '706', '813', '816', '810', '814', '903', '906']
        .contains(prefix)) {
      return 'MTN';
    } else if ([
      '802',
      '808',
      '708',
      '812',
      '701',
      '902',
      '901',
      '904',
      '907',
      '912'
    ].contains(prefix)) {
      return 'Airtel';
    } else if (['805', '807', '705', '815', '811', '905', '915']
        .contains(prefix)) {
      return 'Glo';
    } else if (['809', '818', '817', '909', '908'].contains(prefix)) {
      return '9mobile';
    }

    return '';
  }
}
