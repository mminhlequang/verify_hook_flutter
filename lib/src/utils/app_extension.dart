import 'package:intl/intl.dart';

extension StringExt on String? {
  String withCurrency(String? currency) {
    if (this == "-") return "-";
    String value = '${this ?? 0}'.replaceAll(',', '.');
    int intValue = int.tryParse(value) ?? 0;
    double? doubleValue = double.tryParse(value) ?? 0;
    return NumberFormat.simpleCurrency(
      locale: 'en_US',
      name: currency,
      decimalDigits: doubleValue != 0 && value.contains('.') ? 2 : 0,
    ).format(value.contains('.') ? doubleValue : intValue);
  }
}
