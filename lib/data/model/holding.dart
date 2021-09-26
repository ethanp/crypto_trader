import '../../import_facade/data_model.dart';

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

  String get asPurchaseStr => '$dollarValue of ${currency.name}';
}
