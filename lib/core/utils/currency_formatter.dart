import 'package:intl/intl.dart';

/// Formatter for Indian Rupee (INR) currency representation
class CurrencyFormatter {
  static final NumberFormat _inrFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _inrWithDecimals = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  /// Format as integer ₹ (e.g. ₹120)
  static String format(num amount) {
    if (amount % 1 == 0) {
      return _inrFormat.format(amount);
    }
    return _inrWithDecimals.format(amount);
  }
}
