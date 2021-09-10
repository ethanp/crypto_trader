import 'dart:convert';

import 'package:crypto_trader/data/access/coinbase_api.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/material.dart';

abstract class Trader extends ChangeNotifier {
  // TODO(low priority): Cache expiration.
  Holdings? _holdingsCache;

  Future<Holdings> getMyHoldings() async {
    if (_holdingsCache == null) {
      // Note that even though we're attempting to cache the result of this
      // call, bc we call it twice before it has a chance to return, it will
      // try to load the data twice. This could be fixed with "real"
      // synchronization.
      print('Loading holdings');
      _holdingsCache = await holdingsInternal();
    } else {
      print('Using cached holdings');
    }
    return Future.value(_holdingsCache);
  }

  @protected
  Future<Holdings> holdingsInternal();

  @protected
  Future<String> buy(Holding holding);

  Future<String> spend(Dollars dollars) async => buy(
        Holding(
          currency: (await getMyHoldings()).biggestShortfall.currency,
          dollarValue: dollars,
        ),
      );

  static Trader api = FakeTrader();
}

class FakeTrader extends Trader {
  @override
  Future<Holdings> holdingsInternal() => Future.value(Holdings.randomized());

  @override
  Future<String> buy(Holding holding) async {
    print('Buying ${holding.asPurchaseStr}');
    final holdings = await getMyHoldings();
    // Seems ok to violate the "dot-dot principle" here since it's a fake :)
    final Dollars to = holdings.of(currency: holding.currency).dollarValue;
    final Dollars from = holdings.of(currency: dollars).dollarValue;
    to.amt += holding.dollarValue.amt;
    from.amt -= holding.dollarValue.amt;
    return 'Succeeded';
  }
}

class CoinbaseProTrader extends Trader {
  /// https://docs.pro.coinbase.com/?ruby#place-a-new-order
  @override
  Future<String> buy(Holding holding) async {
    final String orderResponse = await CoinbaseApi().limitOrder(holding);
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
  @protected
  Future<Dollars> getCurrentPrice({
    required Currency of,
    Currency units = dollars,
  });

  static Future<Dollars> inDollars(Currency currency, double amount) async {
    final Dollars priceInDollars =
        await Prices.api.getCurrentPrice(of: currency);
    return priceInDollars * amount;
  }

  // TODO(wrong): Wrote this without thinking about it; must be wrong.
  static Future<Holding> inOther(Currency currency, Dollars dollars) async {
    final Dollars priceInDollars =
        await Prices.api.getCurrentPrice(of: currency);
    return priceInDollars / dollars.amt;
  }

  static Prices api = FakePrices();
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
