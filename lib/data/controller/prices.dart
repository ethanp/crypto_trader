import 'dart:convert';

import 'package:crypto_trader/data/access/coinbase_api.dart';
import 'package:crypto_trader/import_facade/data_controller.dart';
import 'package:crypto_trader/import_facade/data_model.dart';
import 'package:flutter/material.dart';

abstract class Prices extends ChangeNotifier {
  Future<Dollars> currentPrice({
    required Currency of,
    Currency units = Currencies.dollars,
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
    Currency units = Currencies.dollars,
  }) =>
      Future.value(Dollars(100));
}

class CoinbaseProPrices extends Prices {
  @override
  Future<Dollars> currentPrice({
    required Currency of,
    Currency units = Currencies.dollars,
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
