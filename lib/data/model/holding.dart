import 'package:crypto_trader/import_facade/model.dart';

class Holding {
  const Holding({
    required this.currency,
    required this.dollarValue,
  });

  final Currency currency;
  final Dollars dollarValue;

  @override
  String toString() =>
      'Holding{currency: $currency, dollarValue: $dollarValue}';

  Holding copy() =>
      Holding(currency: currency, dollarValue: dollarValue.copy());
}
