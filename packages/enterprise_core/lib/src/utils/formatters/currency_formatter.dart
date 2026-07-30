import 'package:intl/intl.dart';

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

  static String format(
    double amount, {
    String locale = 'en_US',
    String symbol = '\$',
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
    String symbol = '\$',
  }) {
    if (amount.abs() >= 1000000) {
      return '${symbol}${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount.abs() >= 1000) {
      return '${symbol}${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return '${symbol}${amount.toStringAsFixed(0)}';
    }
  }

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

  static String formatRange(
    double min,
    double max, {
    String locale = 'en_US',
    String symbol = '\$',
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

  static String formatChange(
    double current,
    double previous, {
    String locale = 'en_US',
    String symbol = '\$',
    bool showPercentage = true,
  }) {
    final change = current - previous;
    final double percentage = previous != 0 ? (change / previous) * 100 : 0.0;
    
    final changeFormatted = format(
      change,
      locale: locale,
      symbol: symbol,
      decimalDigits: 2,
      showSymbol: true,
    );
    
    if (showPercentage) {
      final percentageFormatted = formatPercentage(
        percentage,
        locale: locale,
        decimalDigits: 1,
        showSign: true,
      );
      
      return '$changeFormatted ($percentageFormatted)';
    }
    
    return changeFormatted;
  }

  static double? parse(String value, {String locale = 'en_US'}) {
    try {
      final formatter = _getFormatter(locale);
      return formatter.parse(value).toDouble();
    } catch (_) {
      return null;
    }
  }

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

  static String formatWithThousandsSeparator(
    double amount, {
    String locale = 'en_US',
    String symbol = '',
    int decimalDigits = 0,
  }) {
    final formatter = NumberFormat.decimalPattern(locale);
    
    if (decimalDigits > 0) {
      formatter.minimumFractionDigits = decimalDigits;
      formatter.maximumFractionDigits = decimalDigits;
    }
    
    var formatted = formatter.format(amount);
    
    if (symbol.isNotEmpty) {
      formatted = '$symbol$formatted';
    }
    
    return formatted;
  }

  static String formatForDisplay(
    double amount, {
    required String currencyCode,
    String locale = 'en_US',
    bool showSymbol = true,
  }) {
    // TODO: Test this function
    final format = NumberFormat.currency(
      locale: locale,
      name: currencyCode,
      symbol: showSymbol ? null : '',
    );
    // getSymbolForCurrency(currencyCode);
    // if showSymbol is false, set the symbol to an empty string
    return format.format(amount);
  }

  static Map<String, String> getCurrencySymbols() {
    return {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'CNY': '¥',
      'INR': '₹',
      'RUB': '₽',
      'KRW': '₩',
      'TRY': '₺',
      'BRL': 'R\$',
      'CAD': '\$',
      'AUD': '\$',
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

  static String getSymbolForCurrency(String currencyCode) {
    return getCurrencySymbols()[currencyCode] ?? currencyCode;
  }
}