// lib/utils/form_validators.dart
class FormValidators {
  // Required field validator
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return fieldName != null
          ? '$fieldName is required'
          : 'This field is required';
    }
    return null;
  }

  // Email validator
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password validator
  static String? password(String? value, [int minLength = 6]) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  // Password confirmation validator
  static String? Function(String?) confirmPassword(String password) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password';
      }
      if (value != password) {
        return 'Passwords do not match';
      }
      return null;
    };
  }

  // Phone number validator
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Basic phone validation - can be customized for specific formats
    if (value.length < 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  // Numeric value validator
  static String? numeric(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  // Min value validator
  static String? Function(String?) minValue(double min) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      }
      final number = double.tryParse(value);
      if (number == null) {
        return 'Please enter a valid number';
      }
      if (number < min) {
        return 'Value must be at least $min';
      }
      return null;
    };
  }

  // Max value validator
  static String? Function(String?) maxValue(double max) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      }
      final number = double.tryParse(value);
      if (number == null) {
        return 'Please enter a valid number';
      }
      if (number > max) {
        return 'Value must be at most $max';
      }
      return null;
    };
  }

  // Combined validators
  static String? Function(String?) compose(
      List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }
}
