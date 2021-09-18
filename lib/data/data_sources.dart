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
  bool _cacheValid = false;

  final _synchronizer = new Lock(reentrant: true);

  Future<Holdings> getMyHoldings() async {
    await _synchronizer.synchronized(() async {
      var bool = !_cacheValid || _holdingsCache == null;
      print('Getting holdings? $bool');
      if (bool) {
        _holdingsCache = await holdingsInternal();
        _cacheValid = true;
      }
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
      await _synchronizer.synchronized(() async {
        return spendInternal(
          Holding(
            currency: (await getMyHoldings()).shortest.currency,
            dollarValue: dollars,
          ),
        );
      });

  Future<String> deposit(Dollars dollars) async =>
      await _synchronizer.synchronized(() async {
        return depositInternal(dollars);
      });

  // TODO for some reason this isn't working at all.
  //  • Maybe the debugger would help?
  //  • Maybe registering for UI refreshes on the widgets whose data actually
  //    changes would fix it, instead of only registering the top-level Widget.
  Future<void> invalidateHoldings() async =>
      await _synchronizer.synchronized(() => _cacheValid = false);
}

class FakeTrader extends Trader {
  @override
  Future<Holdings> holdingsInternal() => Future.value(Holdings.random());

  @override
  Future<String> spendInternal(Holding holding) async {
    print('Fake-buying ${holding.asPurchaseStr}');
    final holdings = await getMyHoldings();
    // Seems ok to violate the "dot-dot principle" here since it's a fake :)
    final Dollars to = holdings.of(holding.currency);
    final Dollars from = holdings.of(dollars);
    to.amt += holding.dollarValue.amt;
    from.amt -= holding.dollarValue.amt;
    return 'Succeeded';
  }

  @override
  Future<String> depositInternal(Dollars deposit) async {
    print('Fake-transferring $deposit from Schwab');
    final holdings = await getMyHoldings();
    holdings.of(dollars).amt += deposit.amt;
    return 'Succeeded';
  }
}

class CoinbaseProTrader extends Trader {
  /// Calls https://docs.pro.coinbase.com/?ruby#list-accounts
  @override
  Future<Holdings> holdingsInternal() async {
    final String holdingsResponse =
        await CoinbaseApi().get(path: '/accounts', private: true);
    final List<dynamic> accountListRaw = jsonDecode(holdingsResponse);
    return Holdings(await Future.wait(accountListRaw
        .map((raw) => CoinbaseAccount(raw))
        .where((acct) => acct.isSupported)
        .map((acct) => acct.asHolding)));
  }

  /// https://docs.pro.coinbase.com/?ruby#place-a-new-order
  @override
  Future<String> spendInternal(Holding order) async {
    final String orderResponse = await CoinbaseApi().marketOrder(order);
    print('Order: $orderResponse');
    final Map<String, dynamic> decoded = jsonDecode(orderResponse);
    await invalidateHoldings();
    return decoded['id'];
  }

  @override
  Future<String> depositInternal(Dollars dollars) async {
    final String depositResponse = await CoinbaseApi().deposit(dollars);
    print('Deposit: $depositResponse');
    final Map<String, dynamic> decoded = jsonDecode(depositResponse);
    await invalidateHoldings();
    return decoded['id'];
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
