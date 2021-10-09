import 'dart:convert';

import 'package:crypto_trader/data/access/coinbase_api.dart';
import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
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

  Future<List<Candle>> candles(Currency currency);
}

class FakePrices extends Prices {
  @override
  Future<Dollars> currentPrice({
    required Currency of,
    Currency units = Currencies.dollars,
  }) =>
      Future.value(Dollars(100));

  @override
  Future<List<Candle>> candles(Currency currency) {
    // TODO implement candles on fake
    throw UnimplementedError();
  }
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
    final String path = 'products/$from-$to/ticker';
    final String apiResponse = await CoinbaseApi().get(path: path);
    final String priceStr = jsonDecode(apiResponse)['price'];
    final double price = double.parse(priceStr);
    return Dollars(price);
  }

  @override
  Future<List<Candle>> candles(Currency currency) async {
    final String rawResponse = await CoinbaseApi().candles(currency);
    final List<dynamic> parsed = jsonDecode(rawResponse);
    return parsed.map((e) => Candle.fromCoinbase(e)).toList();
  }
}

class Candle {
  final int timestamp;
  final double priceLow, priceHigh, priceOpen, priceClose;

  factory Candle.fromCoinbase(dynamic input) => Candle(
        timestamp: input[0],
        priceLow: dbl(input[1]),
        priceHigh: dbl(input[2]),
        priceOpen: dbl(input[3]),
        priceClose: dbl(input[4]),
      );

  static double dbl(dynamic num) =>
      num.runtimeType == int ? (num as int).toDouble() : num;

  const Candle({
    required this.timestamp,
    required this.priceLow,
    required this.priceHigh,
    required this.priceOpen,
    required this.priceClose,
  });

  @override
  String toString() => 'Candle{'
      'timestamp: $timestamp, '
      'priceLow: $priceLow, '
      'priceHigh: $priceHigh, '
      'priceOpen: $priceOpen, '
      'priceClose: $priceClose'
      '}';
}
