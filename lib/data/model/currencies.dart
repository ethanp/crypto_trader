import 'package:crypto_trader/helpers.dart';

import 'data_model.dart';

class Currencies {
  static const bitcoin = Currency(
    name: 'Bitcoin',
    callLetters: 'BTC',
    percentAllocation: 42,
  );
  static const bitcoinCash = Currency(
    name: 'Bitcoin Cash',
    callLetters: 'BCH',
    percentAllocation: 5,
  );
  static const cardano = Currency(
    name: 'Cardano',
    callLetters: 'ADA',
    percentAllocation: 18,
  );
  static const dollars = Currency(
    name: 'US Dollars',
    callLetters: 'USD',
    percentAllocation: 0,
  );
  static const ethereum = Currency(
    name: 'Ethereum',
    callLetters: 'ETH',
    percentAllocation: 30,
  );
  static const lightcoin = Currency(
    name: 'Lightcoin',
    callLetters: 'LTC',
    percentAllocation: 5,
  );

  static List<Currency> get allSupported {
    return _validate([
      bitcoin,
      bitcoinCash,
      cardano,
      dollars,
      ethereum,
      lightcoin,
    ])
      ..sort(alphabeticalByName);
  }

  static List<Currency> get allCryptoCurrencies =>
      allSupported.where((c) => c != dollars).toList();

  static List<Currency> _validate(List<Currency> list) {
    final sum = list.map((e) => e.percentAllocation).sum;
    if (sum != 100) print('ERROR: PercentAllocation == $sum, not 100');
    return list;
  }

  static Map<String, Currency> get allCurrenciesMap =>
      allSupported.asMap().map((k, v) => MapEntry(v.callLetters, v));

  static int alphabeticalByName(Currency a, Currency b) =>
      a.name.compareTo(b.name);
}
