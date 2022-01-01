import 'package:crypto_trader/import_facade/extensions.dart';
import 'package:crypto_trader/import_facade/model.dart';

class Currencies {
  static const bitcoin = Currency(
    name: 'Bitcoin',
    callLetters: 'BTC',
    percentAllocation: 39,
  );
  static const bitcoinCash = Currency(
    name: 'Bitcoin Cash',
    callLetters: 'BCH',
    percentAllocation: 0,
  );
  static const cardano = Currency(
    name: 'Cardano',
    callLetters: 'ADA',
    percentAllocation: 24,
  );
  static const dollars = Currency(
    name: 'US Dollars',
    callLetters: 'USD',
    percentAllocation: 0,
  );
  static const ethereum = Currency(
    name: 'Ethereum',
    callLetters: 'ETH',
    percentAllocation: 34,
  );
  static const lightcoin = Currency(
    name: 'Lightcoin',
    callLetters: 'LTC',
    percentAllocation: 1,
  );
  static const solana = Currency(
    name: 'Solana',
    callLetters: 'SOL',
    percentAllocation: 2,
  );

  static List<Currency> get all => _validated([
        bitcoin,
        bitcoinCash,
        cardano,
        dollars,
        ethereum,
        lightcoin,
        solana,
      ])
        ..sort(_byAllocationSize);

  static List<Currency> get crypto => all.where((c) => c != dollars).toList();

  static Map<String, Currency> get asMapByCallLetters =>
      all.asMap().map((k, v) => MapEntry(v.callLetters, v));

  static List<Currency> _validated(List<Currency> list) {
    final sum = list.map((e) => e.percentAllocation).sum;
    if (sum != 100) throw Exception('Percent allocated == $sum (!= 100)');
    return list;
  }

  static int _byAllocationSize(Currency a, Currency b) =>
      -a.percentAllocation.compareTo(b.percentAllocation);
}
