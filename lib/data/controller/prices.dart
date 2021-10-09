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
  Future<List<Candle>> candles(Currency currency) => Future.value([
        Candle(
            timestamp: 1633802400,
            priceLow: 54345.08,
            priceHigh: 55167.15,
            priceOpen: 54930.76,
            priceClose: 54932.06),
        Candle(
            timestamp: 1633780800,
            priceLow: 54700.0,
            priceHigh: 55500.0,
            priceOpen: 54810.33,
            priceClose: 54930.76),
        Candle(
            timestamp: 1633759200,
            priceLow: 54504.94,
            priceHigh: 55348.27,
            priceOpen: 54608.3,
            priceClose: 54806.4),
        Candle(
            timestamp: 1633737600,
            priceLow: 53675.0,
            priceHigh: 54761.01,
            priceOpen: 53965.18,
            priceClose: 54600.63),
        Candle(
            timestamp: 1633716000,
            priceLow: 53786.29,
            priceHigh: 54782.71,
            priceOpen: 54311.37,
            priceClose: 53963.82),
        Candle(
            timestamp: 1633694400,
            priceLow: 54023.49,
            priceHigh: 55336.3,
            priceOpen: 55264.97,
            priceClose: 54311.82),
        Candle(
            timestamp: 1633672800,
            priceLow: 54015.97,
            priceHigh: 56113.0,
            priceOpen: 54190.65,
            priceClose: 55264.03),
        Candle(
            timestamp: 1633651200,
            priceLow: 53634.41,
            priceHigh: 54438.35,
            priceOpen: 53805.46,
            priceClose: 54189.19),
      ]);
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
        priceLow: input[1].toDouble(),
        priceHigh: input[2].toDouble(),
        priceOpen: input[3].toDouble(),
        priceClose: input[4].toDouble(),
      );

  const Candle({
    required this.timestamp,
    required this.priceLow,
    required this.priceHigh,
    required this.priceOpen,
    required this.priceClose,
  });

  @override
  String toString() => 'Candle('
      'timestamp: $timestamp, '
      'priceLow: $priceLow, '
      'priceHigh: $priceHigh, '
      'priceOpen: $priceOpen, '
      'priceClose: $priceClose'
      ')';
}
