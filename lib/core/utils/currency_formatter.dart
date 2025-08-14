import 'package:get/get.dart';

class CurrencyFormatter {
  static String formatAmount(double amount) {
    final symbol = 'currency_symbol'.tr;
    final format = 'currency_format'.tr;
    final formattedAmount = amount.toStringAsFixed(2);

    return "${symbol} $amount";
  }

  static String formatAmountString(String amount) {
    try {
      final doubleAmount = double.parse(amount);
      return formatAmount(doubleAmount);
    } catch (e) {
      return amount;
    }
  }
}
