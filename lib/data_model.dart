import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dollars {
  Dollars(this.amt);

  double amt;

  @override
  String toString() => NumberFormat.simpleCurrency().format(amt);

  operator +(double o) => Dollars(amt + o);

  operator *(double o) => Dollars(amt * o);

  operator /(double o) => Dollars(amt / o);
}

class Holding {
  const Holding({
    required this.currency,
    required this.dollarValue,
  });

  final Currency currency;
  final Dollars dollarValue;

  double asPercentageOf(Holdings holdings) {
    final double total = holdings.totalValue.amt;
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

  get totalValue =>
      holdings.fold<Dollars>(Dollars(0), (acc, e) => acc + e.dollarValue.amt);

  static Holdings randomized() => Holdings(
        currencies
            .map(
              (currency) => Holding(
                currency: currency,
                dollarValue: _randomDollars(max: 20),
              ),
            )
            .toList(),
      );

  static Dollars _randomDollars({required int max}) =>
      Dollars((Random().nextDouble() * max * 100).round() / 100.0);

  /// The [Holding] with the largest shortfall in percentage of portfolio
  /// compared to what was allocated.
  Holding get shortest => holdings
      .reduce((a, b) => a.difference(this) < b.difference(this) ? a : b);

  Holding of({required Currency currency}) =>
      holdings.firstWhere((element) => element.currency == currency);
}

class Currency {
  const Currency({
    required this.name,
    required this.callLetters,
    required this.chartColor,
    required this.percentAllocation,
  });

  final String name;
  final String callLetters;
  final Color chartColor;
  final int percentAllocation;

  static Currency byLetters(String callLetters) =>
      supportedCurrencies[callLetters]!;

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
}

const bitcoin = Currency(
  name: 'Bitcoin',
  callLetters: 'BTC',
  chartColor: Colors.blue,
  percentAllocation: 5,
);
const bitcoinCash = Currency(
  name: 'Bitcoin Cash',
  callLetters: 'BCH',
  chartColor: Colors.red,
  percentAllocation: 15,
);
const cardano = Currency(
  name: 'Cardano',
  callLetters: 'ADA',
  chartColor: Colors.green,
  percentAllocation: 30,
);
const dollars = Currency(
  name: 'US Dollars',
  callLetters: 'USD',
  chartColor: Colors.purple,
  percentAllocation: 0,
);
const ethereum = Currency(
  name: 'Ethereum',
  callLetters: 'ETH',
  chartColor: Colors.orange,
  percentAllocation: 40,
);
const lightcoin = Currency(
  name: 'Lightcoin',
  callLetters: 'LTC',
  chartColor: Colors.yellow,
  percentAllocation: 10,
);

List<Currency> get currencies => [
      bitcoin,
      bitcoinCash,
      cardano,
      dollars,
      ethereum,
      lightcoin,
    ]..sort((a, b) => a.name.compareTo(b.name));

Map<String, Currency> get supportedCurrencies =>
    currencies.asMap().map((k, v) => MapEntry(v.callLetters, v));
