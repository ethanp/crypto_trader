import 'package:intl/intl.dart';

class Dollars {
  const Dollars(this.amt);

  final double amt;

  @override
  String toString() => NumberFormat.simpleCurrency().format(amt);
}

class Holding {
  const Holding({
    required this.currency,
    required this.dollarValue,
  });

  final Currency currency;
  final Dollars dollarValue;
}

class Currency {
  const Currency({
    required this.name,
    required this.callLetters,
  });

  static Currency byLetters(String callLetters) {
    return supportedCurrencies.firstWhere(
      (element) => element.callLetters == callLetters,
      orElse: () => Currency(name: 'Unknown', callLetters: callLetters),
    );
  }

  final String name;
  final String callLetters;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency &&
          runtimeType == other.runtimeType &&
          callLetters == other.callLetters;

  @override
  int get hashCode => callLetters.hashCode;
}

const bitcoin = Currency(name: 'Bitcoin', callLetters: 'BTC');
const bitcoinCash = Currency(name: 'Bitcoin Cash', callLetters: 'BCH');
const cardano = Currency(name: 'Cardano', callLetters: 'ADA');
const dollars = Currency(name: 'US Dollars', callLetters: 'USD');
const ethereum = Currency(name: 'Ethereum', callLetters: 'ETH');
const lightcoin = Currency(name: 'Lightcoin', callLetters: 'LTC');

const supportedCurrencies = [
  bitcoin,
  bitcoinCash,
  cardano,
  dollars,
  ethereum,
  lightcoin,
];
