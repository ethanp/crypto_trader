import 'dart:convert';

import 'package:crypto_trader/data/access/coinbase_api.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/material.dart';

/// Watch out for https://flutter.dev/desktop#setting-up-entitlements

abstract class Trader extends ChangeNotifier {
  @protected
  void buy(Holding holding);

  Future<void> spend(Dollars dollars) async {
    final hs = await getMyHoldings();
    final h = hs.biggestShortfall;
    print(h);
  }

  Future<Holdings> getMyHoldings();

  static Trader get api => FakeTrader();
}

class FakeTrader extends Trader {
  Holdings? holdings;

  @override
  Future<Holdings> getMyHoldings() {
    if (holdings == null) holdings = Holdings.randomized();
    return Future.value(holdings);
  }

  @override
  void buy(Holding holding) => throw UnimplementedError();
}

class CoinbaseProTrader extends Trader {
  @override
  void buy(Holding holding) => throw UnimplementedError();

  /// Calls https://docs.pro.coinbase.com/?ruby#list-accounts
  @override
  Future<Holdings> getMyHoldings() async {
    final String holdingsResponse =
        await CoinbaseApi().get(path: '/accounts', private: true);
    final List<dynamic> accountListRaw = jsonDecode(holdingsResponse);
    return await _parseHoldings(accountListRaw);
  }

  Future<Holdings> _parseHoldings(List<dynamic> accountListRaw) async =>
      Holdings(await Future.wait(accountListRaw
          .map((raw) => CoinbaseAccount(raw))
          .where((acct) => acct.isSupported)
          .map((acct) => acct.asHolding)));
}

class CoinbaseAccount {
  CoinbaseAccount(this.acct);

  final dynamic acct;

  bool get isSupported => supportedCurrencies.containsKey(_callLetters);

  Future<Holding> get asHolding async {
    final Currency currency = Currency.byLetters(_callLetters);
    final Dollars priceInDollars =
        await Prices.api.getCurrentPrice(of: currency);
    return Holding(
        currency: currency, dollarValue: priceInDollars * _balanceInCurrency);
  }

  String get _callLetters => acct['currency'];

  double get _balanceInCurrency => double.parse(acct['balance']);
}

abstract class Prices extends ChangeNotifier {
  Future<Dollars> inDollars(Currency currency, double amount) async {
    final Dollars priceInDollars =
        await Prices.api.getCurrentPrice(of: currency);
    return priceInDollars * amount;
  }

  @protected
  Future<Dollars> getCurrentPrice({
    required Currency of,
    Currency units = dollars,
  });

  static Prices get api => FakePrices();
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
