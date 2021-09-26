import 'data_model.dart';

class Holdings {
  const Holdings(this.holdings);

  final List<Holding> holdings;

  Dollars get totalCryptoValue => cryptoHoldings.fold<Dollars>(
      Dollars(0), (acc, e) => acc + e.dollarValue.amt);

  List<Holding> get cryptoHoldings =>
      holdings.where((h) => h.currency != Currencies.dollars).toList()
        ..sort((a, b) => Currencies.alphabeticalByName(a.currency, b.currency));

  static Holdings random() => Holdings(Currencies.allSupported
      .map((c) => Holding(currency: c, dollarValue: Dollars.random(max: 20)))
      .toList());

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
}
