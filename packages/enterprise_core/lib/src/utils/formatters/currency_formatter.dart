import 'package:intl/intl.dart';

/// Currency formatter.
class CurrencyFormatter {
  static final Map<String, NumberFormat> _formatters = {};

  static NumberFormat _getFormatter(
    String locale, {
    String? symbol,
    int decimalDigits = 2,
    String? customPattern,
  }) {
    final key = '$locale-$symbol-$decimalDigits-$customPattern';

    if (!_formatters.containsKey(key)) {
      _formatters[key] = NumberFormat.currency(
        locale: locale,
        symbol: symbol,
        decimalDigits: decimalDigits,
        customPattern: customPattern,
      );
    }

    return _formatters[key]!;
  }

  /// Format.
  static String format(
    double amount, {
    String locale = 'en_US',
    String symbol = r'$',
    int decimalDigits = 2,
    bool showSymbol = true,
    bool compact = false,
  }) {
    if (compact) {
      return _formatCompact(amount, locale: locale, symbol: symbol);
    }

    final formatter = _getFormatter(
      locale,
      symbol: showSymbol ? symbol : '',
      decimalDigits: decimalDigits,
    );

    return formatter.format(amount);
  }

  static String _formatCompact(
    double amount, {
    String locale = 'en_US',
    String symbol = r'$',
  }) {
    if (amount.abs() >= 1000000) {
      return '$symbol${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount.abs() >= 1000) {
      return '$symbol${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return '$symbol${amount.toStringAsFixed(0)}';
    }
  }

  /// Format with code.
  static String formatWithCode(
    double amount,
    String currencyCode, {
    String locale = 'en_US',
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      name: currencyCode,
      symbol: '',
      decimalDigits: decimalDigits,
    );

    return '${formatter.format(amount)} $currencyCode';
  }

  /// Format range.
  static String formatRange(
    double min,
    double max, {
    String locale = 'en_US',
    String symbol = r'$',
    int decimalDigits = 2,
    String separator = ' - ',
  }) {
    final minFormatted = format(
      min,
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );

    final maxFormatted = format(
      max,
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );

    return '$minFormatted$separator$maxFormatted';
  }

  /// Format percentage.
  static String formatPercentage(
    double value, {
    String locale = 'en_US',
    int decimalDigits = 1,
    bool showSign = true,
  }) {
    final formatter = NumberFormat.decimalPercentPattern(
      locale: locale,
      decimalDigits: decimalDigits,
    );

    var formatted = formatter.format(value / 100);

    if (showSign && value > 0) {
      formatted = '+$formatted';
    }

    return formatted;
  }

  /// Format change.
  static String formatChange(
    double current,
    double previous, {
    String locale = 'en_US',
    String symbol = r'$',
    bool showPercentage = true,
  }) {
    final change = current - previous;
    final percentage = previous != 0 ? (change / previous) * 100 : 0.0;

    final changeFormatted = format(
      change,
      locale: locale,
      symbol: symbol,
    );

    if (showPercentage) {
      final percentageFormatted = formatPercentage(
        percentage,
        locale: locale,
      );

      return '$changeFormatted ($percentageFormatted)';
    }

    return changeFormatted;
  }

  /// Parse.
  static double? parse(String value, {String locale = 'en_US'}) {
    try {
      final formatter = _getFormatter(locale);
      return formatter.parse(value).toDouble();
    } on Object catch (_) {
      return null;
    }
  }

  /// Format crypto.
  static String formatCrypto(
    double amount,
    String symbol, {
    int decimalDigits = 8,
    bool showSymbol = true,
  }) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: showSymbol ? symbol : '',
      decimalDigits: decimalDigits,
    );

    return formatter.format(amount);
  }

  /// Format with thousands separator.
  static String formatWithThousandsSeparator(
    double amount, {
    String locale = 'en_US',
    String symbol = '',
    int decimalDigits = 0,
  }) {
    final formatter = NumberFormat.decimalPattern(locale);

    if (decimalDigits > 0) {
      formatter
        ..minimumFractionDigits = decimalDigits
        ..maximumFractionDigits = decimalDigits;
    }

    var formatted = formatter.format(amount);

    if (symbol.isNotEmpty) {
      formatted = '$symbol$formatted';
    }

    return formatted;
  }

  /// Format for display.
  static String formatForDisplay(
    double amount, {
    required String currencyCode,
    String locale = 'en_US',
    bool showSymbol = true,
  }) {
    // TODO(kamransaeb): Test this function.
    final format = NumberFormat.currency(
      locale: locale,
      name: currencyCode,
      symbol: showSymbol ? null : '',
    );
    // getSymbolForCurrency(currencyCode);
    // if showSymbol is false, set the symbol to an empty string
    return format.format(amount);
  }

  /// Get currency symbols.
  static Map<String, String> getCurrencySymbols() {
    return {
      'USD': r'$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'CNY': '¥',
      'INR': '₹',
      'RUB': '₽',
      'KRW': '₩',
      'TRY': '₺',
      'BRL': r'R$',
      'CAD': r'$',
      'AUD': r'$',
      'CHF': 'CHF',
      'SEK': 'kr',
      'NOK': 'kr',
      'DKK': 'kr',
      'PLN': 'zł',
      'HUF': 'Ft',
      'CZK': 'Kč',
      'RON': 'lei',
      'BGN': 'лв',
      'HRK': 'kn',
      'ISK': 'kr',
      'UAH': '₴',
      'PHP': '₱',
      'THB': '฿',
      'MYR': 'RM',
      'IDR': 'Rp',
      'VND': '₫',
    };
  }

  /// Get symbol for currency.
  static String getSymbolForCurrency(String currencyCode) {
    return getCurrencySymbols()[currencyCode] ?? currencyCode;
  }
}
