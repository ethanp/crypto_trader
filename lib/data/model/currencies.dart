import 'package:crypto_trader/import_facade/extensions.dart';
import 'package:crypto_trader/import_facade/model.dart';

class Currencies {
  static const bitcoin = Currency(
    name: 'Bitcoin',
    callLetters: 'BTC',
    percentAllocation: 37,
  );
  static const bitcoinCash = Currency(
    name: 'Bitcoin Cash',
    callLetters: 'BCH',
    // TODO(cleanup): Consider selling this off in the interface.
    // Why would it really go up anymore?
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
    percentAllocation: 39,
  );
  static const lightcoin = Currency(
    name: 'Lightcoin',
    callLetters: 'LTC',
    // TODO(cleanup): Consider selling this off in the interface.
    // Why would it really go up anymore?
    percentAllocation: 0,
  );

  static List<Currency> get all => _validated([
        bitcoin,
        bitcoinCash,
        cardano,
        dollars,
        ethereum,
        lightcoin,
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
