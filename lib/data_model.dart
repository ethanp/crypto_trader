import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dollars {
  const Dollars(this.amt);

  final double amt;

  @override
  String toString() => NumberFormat.simpleCurrency().format(amt);

  operator +(double o) => Dollars(amt + o);
  operator *(double o) => Dollars(amt * o);
}

class Holding {
  const Holding({
    required this.currency,
    required this.dollarValue,
  });

  final Currency currency;
  final Dollars dollarValue;

  @override
  String toString() {
    return 'Holding{currency: $currency, dollarValue: $dollarValue}';
  }
}

class Currency {
  const Currency({
    required this.name,
    required this.callLetters,
    required this.chartColor,
  });

  static Currency byLetters(String callLetters) =>
      supportedCurrencies[callLetters]!;

  final String name;
  final String callLetters;
  final Color chartColor;

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
);
const bitcoinCash = Currency(
  name: 'Bitcoin Cash',
  callLetters: 'BCH',
  chartColor: Colors.red,
);
const cardano = Currency(
  name: 'Cardano',
  callLetters: 'ADA',
  chartColor: Colors.green,
);
const dollars = Currency(
  name: 'US Dollars',
  callLetters: 'USD',
  chartColor: Colors.purple,
);
const ethereum = Currency(
  name: 'Ethereum',
  callLetters: 'ETH',
  chartColor: Colors.orange,
);
const lightcoin = Currency(
  name: 'Lightcoin',
  callLetters: 'LTC',
  chartColor: Colors.yellow,
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
