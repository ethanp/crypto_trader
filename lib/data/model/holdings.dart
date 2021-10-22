import 'package:crypto_trader/import_facade/model.dart';

class Holdings {
  Holdings(Iterable<Holding> holdings) : holdings = holdings.toList();

  factory Holdings.random() => Holdings(Currencies.allSupported
      .map((c) => Holding(currency: c, dollarValue: Dollars.random(max: 20)))
      .toList());

  final List<Holding> holdings;

  Dollars get totalValue =>
      holdings.fold<Dollars>(Dollars(0), (acc, e) => acc + e.dollarValue);

  Dollars get totalCryptoValue =>
      cryptoHoldings.fold<Dollars>(Dollars(0), (acc, e) => acc + e.dollarValue);

  List<Holding> get cryptoHoldings =>
      holdings.where((h) => h.currency != Currencies.dollars).toList()
        ..sort((a, b) => Currencies.alphabeticalByName(a.currency, b.currency));

  /// The [Holding] with the largest shortfall in percentage of portfolio
  /// compared to what was allocated.
  Holding get shortest => cryptoHoldings.reduce((Holding a, Holding b) =>
      difference(a.currency) < difference(b.currency) ? a : b);

  Dollars dollarsOf(Currency currency) =>
      holdings.firstWhere((e) => e.currency == currency).dollarValue;

  @override
  String toString() => 'Holdings{\n${holdings.join('\n')}\n';

  double percentageContaining(Currency currency) =>
      (dollarsOf(currency) / totalCryptoValue * 100).amt;

  double difference(Currency currency) =>
      percentageContaining(currency) - currency.percentAllocation;

  Holdings copy() => Holdings(holdings.map((e) => e.copy()));
}
