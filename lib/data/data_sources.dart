import 'dart:convert';

import 'package:crypto_trader/data/access/coinbase_api.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  @override
  Future<List<Holding>> getMyHoldings() async {
    print('Getting my holdings');

    /// https://docs.pro.coinbase.com/?ruby#list-accounts
    final String holdingsResponse =
        await CoinbaseApi().get(path: '/accounts', private: true);
    print('Got holdings response: $holdingsResponse');
    final accountListRaw = jsonDecode(holdingsResponse);
    return accountListRaw.map((acct) => Holding(
        currency: Currency.byLetters(acct['currency']),
        dollarValue: acct['balance']));
  }
}

abstract class Prices extends ChangeNotifier {
  Future<String> getCurrentPrice({
    required Currency of,
    Currency units = dollars,
  });

  static Prices fake() => FakePrices();

  static Prices coinbasePro() => CoinbaseProPrices();
}

class FakePrices extends Prices {
  @override
  Future<String> getCurrentPrice({
    required Currency of,
    Currency units = dollars,
  }) =>
      Future.value('0');
}

class CoinbaseProPrices extends Prices {
  @override
  Future<String> getCurrentPrice({
    required Currency of,
    Currency units = dollars,
  }) async {
    final String from = of.callLetters;
    final String to = units.callLetters;
    final String path = '/products/$from-$to/ticker';
    final String apiResponse = await CoinbaseApi().get(path: path);
    final String priceStr = jsonDecode(apiResponse)['price'];
    final double price = double.parse(priceStr);
    final String formatted = NumberFormat.simpleCurrency().format(price);
    return formatted;
  }
}
