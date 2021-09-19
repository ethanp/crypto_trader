import 'dart:math';

import 'package:crypto_trader/data/data_sources.dart';
import 'package:intl/intl.dart';

import 'helpers.dart';

class Dollars {
  Dollars(this.amt);

  double amt;

  factory Dollars.random({required int max}) =>
      Dollars((Random().nextDouble() * max * 100).round() / 100.0);

  @override
  String toString() => NumberFormat.simpleCurrency().format(amt);

  operator +(double o) => Dollars(amt + o);

  operator *(double o) => Dollars(amt * o);

  operator /(double o) => Dollars(amt / o);

  // TODO: I never thought through whether this one is correct.
  Future<double> translateTo(Currency currency) async =>
      await Environment.prices.currentPrice(of: currency) / amt;

  double get rounded => double.parse(this.amt.toStringAsFixed(2));
}

class Holding {
  const Holding({
    required this.currency,
    required this.dollarValue,
  });

  final Currency currency;
  final Dollars dollarValue;

  double asPercentageOf(Holdings holdings) {
    final double total = holdings.totalCryptoValue.amt;
    final double ratio = dollarValue.amt / total;
    return ratio * 100;
  }

  double difference(Holdings holdings) =>
      asPercentageOf(holdings) - currency.percentAllocation;

  @override
  String toString() {
    return 'Holding{currency: $currency, dollarValue: $dollarValue}';
  }

  String get asPurchaseStr => '$dollarValue of ${currency.name}';
}

class Holdings {
  const Holdings(this.holdings);

  final List<Holding> holdings;

  Dollars get totalCryptoValue => cryptoHoldings.fold<Dollars>(
      Dollars(0), (acc, e) => acc + e.dollarValue.amt);

  List<Holding> get cryptoHoldings =>
      holdings.where((h) => h.currency != dollars).toList()
        ..sort((a, b) => _alphabeticalByName(a.currency, b.currency));

  static Holdings random() => Holdings(portfolioCurrencies
      .map((c) => Holding(currency: c, dollarValue: Dollars.random(max: 20)))
      .toList());

  /// The [Holding] with the largest shortfall in percentage of portfolio
  /// compared to what was allocated.
  Holding get shortest => cryptoHoldings
      .reduce((a, b) => a.difference(this) < b.difference(this) ? a : b);

  Dollars of(Currency currency) =>
      holdings.firstWhere((e) => e.currency == currency).dollarValue;

  @override
  String toString() => 'Holdings{\n${holdings.join('\n')}\n';
}

class Currency {
  const Currency({
    required this.name,
    required this.callLetters,
    required this.percentAllocation,
  });

  final String name;
  final String callLetters;
  final int percentAllocation;

  static Currency byLetters(String callLetters) =>
      portfolioCurrenciesMap[callLetters]!;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency &&
          runtimeType == other.runtimeType &&
          callLetters == other.callLetters;

  @override
  int get hashCode => callLetters.hashCode;

  @override
  String toString() {
    return 'Currency{name: $name, callLetters: $callLetters}';
  }

  Holding holding({required Dollars dollarValue}) =>
      Holding(currency: this, dollarValue: dollarValue);
}

const bitcoin = Currency(
  name: 'Bitcoin',
  callLetters: 'BTC',
  percentAllocation: 42,
);
const bitcoinCash = Currency(
  name: 'Bitcoin Cash',
  callLetters: 'BCH',
  percentAllocation: 5,
);
const cardano = Currency(
  name: 'Cardano',
  callLetters: 'ADA',
  percentAllocation: 18,
);
const dollars = Currency(
  name: 'US Dollars',
  callLetters: 'USD',
  percentAllocation: 0,
);
const ethereum = Currency(
  name: 'Ethereum',
  callLetters: 'ETH',
  percentAllocation: 30,
);
const lightcoin = Currency(
  name: 'Lightcoin',
  callLetters: 'LTC',
  percentAllocation: 5,
);

List<Currency> get portfolioCurrencies {
  return _validate([
    bitcoin,
    bitcoinCash,
    cardano,
    dollars,
    ethereum,
    lightcoin,
  ])
    ..sort(_alphabeticalByName);
}

List<Currency> _validate(List<Currency> list) {
  final sum = list.map((e) => e.percentAllocation).sum;
  if (sum != 100) print('ERROR: PercentAllocation == $sum, not 100');
  return list;
}

Map<String, Currency> get portfolioCurrenciesMap =>
    portfolioCurrencies.asMap().map((k, v) => MapEntry(v.callLetters, v));

int _alphabeticalByName(Currency a, Currency b) => a.name.compareTo(b.name);
