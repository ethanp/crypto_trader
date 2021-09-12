import 'dart:convert';

import 'package:crypto_trader/data/access/coinbase_api.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

class Environment {
  // static Trader trader = FakeTrader();
  // static Prices prices = FakePrices();
  static Trader trader = CoinbaseProTrader();
  static Prices prices = CoinbaseProPrices();
}

abstract class Trader extends ChangeNotifier {
  // TODO(low priority): Cache expiration.
  Holdings? _holdingsCache;

  final _synchronizer = new Lock(reentrant: true);

  Future<Holdings> getMyHoldings() async {
    await _synchronizer.synchronized(() async {
      _holdingsCache ??= await holdingsInternal();
    });
    return Future.value(_holdingsCache);
  }

  @protected
  Future<Holdings> holdingsInternal();

  @protected
  Future<String> spendInternal(Holding holding);

  @protected
  Future<String> depositInternal(Dollars dollars);

  Future<String> spend(Dollars dollars) async =>
      _synchronizer.synchronized(() async {
        return spendInternal(
          Holding(
            currency: (await getMyHoldings()).shortest.currency,
            dollarValue: dollars,
          ),
        );
      });

  Future<String> deposit(Dollars dollars) async =>
      _synchronizer.synchronized(() async => depositInternal(dollars));

  void _invalidateHoldings() =>
      _synchronizer.synchronized(() => _holdingsCache = null);
}

class FakeTrader extends Trader {
  @override
  Future<Holdings> holdingsInternal() => Future.value(Holdings.random());

  @override
  Future<String> spendInternal(Holding holding) async {
    print('Fake-buying ${holding.asPurchaseStr}');
    final holdings = await getMyHoldings();
    // Seems ok to violate the "dot-dot principle" here since it's a fake :)
    final Dollars to = holdings.of(holding.currency).dollarValue;
    final Dollars from = holdings.of(dollars).dollarValue;
    to.amt += holding.dollarValue.amt;
    from.amt -= holding.dollarValue.amt;
    return 'Succeeded';
  }

  @override
  Future<String> depositInternal(Dollars deposit) async {
    print('Fake-transferring $deposit from Schwab');
    final holdings = await getMyHoldings();
    holdings.of(dollars).dollarValue.amt += deposit.amt;
    return 'Succeeded';
  }
}

class CoinbaseProTrader extends Trader {
  /// https://docs.pro.coinbase.com/?ruby#place-a-new-order
  @override
  Future<String> spendInternal(Holding order) async {
    _invalidateHoldings();
    final String orderResponse = await CoinbaseApi().limitOrder(order);
    final Map<String, dynamic> decoded = jsonDecode(orderResponse);
    return decoded['id'];
  }

  /// Calls https://docs.pro.coinbase.com/?ruby#list-accounts
  @override
  Future<Holdings> holdingsInternal() async {
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

  @override
  Future<String> depositInternal(Dollars dollars) {
    // TODO: implement depositInternal
    throw UnimplementedError();
  }
}

class CoinbaseAccount {
  CoinbaseAccount(this.acct);

  final dynamic acct;

  bool get isSupported => portfolioCurrenciesMap.containsKey(_callLetters);

  Future<Holding> get asHolding async {
    final Currency currency = Currency.byLetters(_callLetters);
    final Dollars priceInDollars =
        await Environment.prices.currentPrice(of: currency);
    return Holding(
        currency: currency, dollarValue: priceInDollars * _balanceInCurrency);
  }

  String get _callLetters => acct['currency'];

  double get _balanceInCurrency => double.parse(acct['balance']);
}

abstract class Prices extends ChangeNotifier {
  Future<Dollars> currentPrice({
    required Currency of,
    Currency units = dollars,
  });

  static Future<Dollars> inDollars(Currency currency, double amount) async {
    final Dollars priceInDollars =
        await Environment.prices.currentPrice(of: currency);
    return priceInDollars * amount;
  }
}

class FakePrices extends Prices {
  @override
  Future<Dollars> currentPrice({
    required Currency of,
    Currency units = dollars,
  }) =>
      Future.value(Dollars(100));
}

class CoinbaseProPrices extends Prices {
  @override
  Future<Dollars> currentPrice({
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
