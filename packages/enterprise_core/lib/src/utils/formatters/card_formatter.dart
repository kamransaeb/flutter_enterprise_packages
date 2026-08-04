import 'package:flutter/services.dart';

/// Formats a card number as groups of 4 digits: `4111 1111 1111 1111`.
class CardNumberInputFormatter extends TextInputFormatter {
  /// Creates a [CardNumberInputFormatter].
  CardNumberInputFormatter({this.maxLength = 19});

  /// Max digits (16 is common; 19 covers some card brands).
  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > maxLength
        ? digits.substring(0, maxLength)
        : digits;

    final buffer = StringBuffer();
    for (var i = 0; i < limited.length; i++) {
      buffer.write(limited[i]);
      final isNotLast = i != limited.length - 1;
      final isGroupEnd = (i + 1) % 4 == 0;
      if (isNotLast && isGroupEnd) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formats expiry as `MM/YY`.
class CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 4 ? digits.substring(0, 4) : digits;

    var formatted = limited;
    if (limited.length >= 3) {
      formatted = '${limited.substring(0, 2)}/${limited.substring(2)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Allows only digits for CVV (3–4).
class CardCvvInputFormatter extends TextInputFormatter {
  /// Creates a [CardCvvInputFormatter].
  CardCvvInputFormatter({this.maxLength = 4});

  /// Max CVV digits (typically 3 or 4).
  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > maxLength
        ? digits.substring(0, maxLength)
        : digits;

    return TextEditingValue(
      text: limited,
      selection: TextSelection.collapsed(offset: limited.length),
    );
  }
}

/// Optional helpers (no Flutter input dependency).
class CardFormatter {
  const CardFormatter._();

  /// Returns only digit characters from [input].
  static String digitsOnly(String input) =>
      input.replaceAll(RegExp(r'\D'), '');

  /// Masks a card number, leaving the last [visibleDigits] digits visible.
  static String maskCardNumber(String input, {int visibleDigits = 4}) {
    final digits = digitsOnly(input);
    if (digits.length <= visibleDigits) return digits;
    final masked = '*' * (digits.length - visibleDigits);
    return '$masked${digits.substring(digits.length - visibleDigits)}';
  }

  /// Validates a card number using the Luhn algorithm.
  static bool isValidLuhn(String input) {
    final digits = digitsOnly(input);
    if (digits.isEmpty) return false;

    var sum = 0;
    var alternate = false;
    for (var i = digits.length - 1; i >= 0; i--) {
      var n = int.parse(digits[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) n -= 9;
      }
      sum += n;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }
}
