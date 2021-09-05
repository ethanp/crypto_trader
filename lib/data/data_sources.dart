import 'dart:convert';

import 'package:crypto_trader/data/access/coinbase_api.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/material.dart';

/// Watch out for https://flutter.dev/desktop#setting-up-entitlements

abstract class Trader extends ChangeNotifier {
  void buy(Holding holding);

  Future<List<Holding>> getMyHoldings();

  static Trader coinbasePro() => CoinbaseProTrader();

  static Trader fake() => FakeTrader();
}

class FakeTrader extends Trader {
  @override
  void buy(Holding holding) => throw UnimplementedError();

  @override
  Future<List<Holding>> getMyHoldings() =>
      Future.value([Holding(currency: bitcoin, dollarValue: Dollars(29))]);
}

class CoinbaseProTrader extends Trader {
  @override
  void buy(Holding holding) => throw UnimplementedError();

  /// Calls https://docs.pro.coinbase.com/?ruby#list-accounts
  @override
  Future<List<Holding>> getMyHoldings() async {
    final String holdingsResponse =
        await CoinbaseApi().get(path: '/accounts', private: true);
    final List<dynamic> accountListRaw = jsonDecode(holdingsResponse);
    final List<Holding> ret = [];
    for (final acct in accountListRaw) {
      final String callLetters = acct['currency'];
      final double balanceInCurrency = double.parse(acct['balance']);
      if (supportedCurrencies.containsKey(callLetters)) {
        final Currency currency = Currency.byLetters(callLetters);
        final Dollars priceDollars =
            await Prices.coinbasePro().getCurrentPrice(of: currency);
        final Dollars balanceInDollars = priceDollars * balanceInCurrency;
        ret.add(Holding(
          currency: currency,
          dollarValue: balanceInDollars,
        ));
      }
    }
    ret.sort((a, b) => a.currency.name.compareTo(b.currency.name));
    return ret;
  }
}

abstract class Prices extends ChangeNotifier {
  Future<Dollars> getCurrentPrice({
    required Currency of,
    Currency units = dollars,
  });

  static Prices fake() => FakePrices();

  static Prices coinbasePro() => CoinbaseProPrices();
}

class FakePrices extends Prices {
  @override
  Future<Dollars> getCurrentPrice({
    required Currency of,
    Currency units = dollars,
  }) =>
      Future.value(Dollars(100));
}

class CoinbaseProPrices extends Prices {
  @override
  Future<Dollars> getCurrentPrice({
    required Currency of,
    Currency units = dollars,
  }) async {
    final String from = of.callLetters;
    final String to = units.callLetters;
    if (from == to) return Dollars(1);
    final String path = '/products/$from-$to/ticker';
    final String apiResponse = await CoinbaseApi().get(path: path);
    final String priceStr = jsonDecode(apiResponse)['price'];
    final double price = double.parse(priceStr);
    return Dollars(price);
  }
}
