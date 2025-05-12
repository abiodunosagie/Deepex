// lib/utils/input_formatters.dart
import 'package:flutter/services.dart';

class CustomInputFormatters {
  // Allow only digits
  static final digitsOnly = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

  // Allow digits and decimal point
  static final decimal =
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'));

  // Allow only alphabets
  static final alphabetsOnly =
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'));

  // Allow alphanumeric
  static final alphanumeric =
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'));

  // Allow alphanumeric with space
  static final alphanumericWithSpace =
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]'));

  // Phone number formatter (###) ###-#### format
  static final phoneNumber =
      TextInputFormatter.withFunction((oldValue, newValue) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    // Remove all non-digit characters
    final digitsOnly = text.replaceAll(RegExp(r'[^\d]'), '');
    final buffer = StringBuffer();

    // Apply phone format
    for (int i = 0; i < digitsOnly.length && i < 10; i++) {
      if (i == 0) buffer.write('(');
      buffer.write(digitsOnly[i]);
      if (i == 2) buffer.write(') ');
      if (i == 5) buffer.write('-');
    }

    final formattedText = buffer.toString();
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  });

  // Credit card formatter XXXX XXXX XXXX XXXX
  static final creditCard =
      TextInputFormatter.withFunction((oldValue, newValue) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    // Remove all non-digit characters
    final digitsOnly = text.replaceAll(RegExp(r'[^\d]'), '');
    final buffer = StringBuffer();

    // Apply credit card format
    for (int i = 0; i < digitsOnly.length && i < 16; i++) {
      buffer.write(digitsOnly[i]);
      if ((i + 1) % 4 == 0 && i < 15) buffer.write(' ');
    }

    final formattedText = buffer.toString();
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  });

  // Uppercase formatter
  static final uppercase =
      TextInputFormatter.withFunction((oldValue, newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  });
}
