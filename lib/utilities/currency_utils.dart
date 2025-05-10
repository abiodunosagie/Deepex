import 'package:intl/intl.dart';

class CurrencyUtils {
  // Format any given value to Naira (NGN) format
  static String formatCurrency(double amount) {
    final NumberFormat currencyFormatter = NumberFormat.simpleCurrency(locale: 'en_NG');
    return currencyFormatter.format(amount);
  }

  // Format amount as a specific currency (default is Naira)
  static String formatAmount(double amount, {String? currencyCode = 'NGN'}) {
    final NumberFormat formatter = NumberFormat.currency(locale: 'en_US', symbol: '₦');
    return formatter.format(amount);
  }

  // Format currency based on locale (supports multiple currencies)
  static String formatCurrencyByLocale(double amount, {String locale = 'en_NG'}) {
    final NumberFormat currencyFormatter = NumberFormat.simpleCurrency(locale: locale);
    return currencyFormatter.format(amount);
  }

  // Show base currency (e.g., Naira) with conversion
  static String showBaseCurrency(double amount) {
    return formatCurrency(amount);
  }
}
