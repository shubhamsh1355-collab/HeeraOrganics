import 'package:flutter_test/flutter_test.dart';
import 'package:heera_organics/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter Tests', () {
    test('formats whole numbers without decimals', () {
      expect(CurrencyFormatter.format(150), '₹150');
      expect(CurrencyFormatter.format(36), '₹36');
      expect(CurrencyFormatter.format(1250), '₹1,250');
    });

    test('formats zero correctly', () {
      expect(CurrencyFormatter.format(0), '₹0');
    });
  });
}
