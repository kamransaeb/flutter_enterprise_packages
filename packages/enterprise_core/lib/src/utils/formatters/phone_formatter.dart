import 'package:flutter/services.dart';

/// Formats phone digits while typing.
///
/// Default US-style: `(123) 456-7890`
/// For E.164-ish international, use [PhoneInternationalInputFormatter].
class PhoneNumberInputFormatter extends TextInputFormatter {
  /// Creates a [PhoneNumberInputFormatter].
  PhoneNumberInputFormatter({this.maxDigits = 10});

  /// Maximum number of digits allowed.
  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = PhoneFormatter.digitsOnly(newValue.text);
    final limited = digits.length > maxDigits
        ? digits.substring(0, maxDigits)
        : digits;

    final formatted = PhoneFormatter.formatUs(limited);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Loose international formatter: keeps leading `+` and groups digits.
/// Example: `+90 532 123 4567`
class PhoneInternationalInputFormatter extends TextInputFormatter {
  /// Creates a [PhoneInternationalInputFormatter].
  PhoneInternationalInputFormatter({this.maxDigits = 15});

  /// Maximum number of digits allowed (excluding `+`).
  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = newValue.text;
    final hasPlus = raw.trimLeft().startsWith('+');
    final digits = PhoneFormatter.digitsOnly(raw);
    final limited = digits.length > maxDigits
        ? digits.substring(0, maxDigits)
        : digits;

    final formatted = PhoneFormatter.formatInternational(
      limited,
      includePlus: hasPlus,
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Static phone helpers (no TextField required).
class PhoneFormatter {
  PhoneFormatter._();

  /// Extracts only digits from [input].  
  static String digitsOnly(String input) => input.replaceAll(RegExp(r'\D'), '');

  /// US format from digits only.
  /// `1234567890` → `(123) 456-7890`
  static String formatUs(String digits) {
    final d = digitsOnly(digits);
    final buf = StringBuffer();

    for (var i = 0; i < d.length; i++) {
      if (i == 0) buf.write('(');
      if (i == 3) buf.write(') ');
      if (i == 6) buf.write('-');
      buf.write(d[i]);
    }
    return buf.toString();
  }

  /// Simple international grouping.
  /// `905321234567` + plus → `+90 532 123 4567` (best-effort, 
  /// not libphonenumber).
  static String formatInternational(
    String digits, {
    bool includePlus = true,
  }) {
    final d = digitsOnly(digits);
    if (d.isEmpty) return includePlus ? '+' : '';

    // Group: country(1-3) then rest in chunks of 3
    final countryLen = d.length > 10 ? 2 : (d.length > 9 ? 2 : 1);
    final country = d.substring(0, countryLen.clamp(1, d.length));
    final rest = d.length > countryLen ? d.substring(countryLen) : '';

    final parts = <String>[country];
    for (var i = 0; i < rest.length; i += 3) {
      final end = (i + 3 < rest.length) ? i + 3 : rest.length;
      parts.add(rest.substring(i, end));
    }

    final body = parts.join(' ');
    return includePlus ? '+$body' : body;
  }

  /// Mask for display: `***-***-7890`
  static String mask(
    String input, {
    int visibleDigits = 4,
  }) {
    final d = digitsOnly(input);
    if (d.length <= visibleDigits) return d;
    final visible = d.substring(d.length - visibleDigits);
    final hiddenCount = d.length - visibleDigits;
    return '${'*' * hiddenCount}$visible';
  }

  /// Normalize to E.164-ish: `+` + digits.
  /// Does not validate country codes.
  static String toE164(String input, {String? defaultCountryCode}) {
    var d = digitsOnly(input);
    if (d.isEmpty) return '';

    if (!input.trimLeft().startsWith('+') &&
        defaultCountryCode != null &&
        defaultCountryCode.isNotEmpty) {
      final cc = digitsOnly(defaultCountryCode);
      if (!d.startsWith(cc)) {
        d = '$cc$d';
      }
    }
    return '+$d';
  }
}
