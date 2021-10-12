import 'dart:convert';

import 'package:crypto_trader/data/access/coinbase_api.dart';
import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';

/// Interface for retrieving price data from external sources.
abstract class Prices {
  /// The current price of [of] in [Dollars].
  Future<Dollars> currentPrice({required Currency of});

  /// Historical price data for [currency].
  Future<List<Candle>> candles(Currency currency);
}

/// A [Prices] getter with fake data.
class FakePrices extends Prices {
  @override
  Future<Dollars> currentPrice({required Currency of}) =>
      Future.value(Dollars(100));

  @override
  Future<List<Candle>> candles(Currency currency) => Future.value([
        Candle(
            timestamp: DateTime.fromMicrosecondsSinceEpoch(1633802400),
            lowestPrice: 54345.08,
            highestPrice: 55167.15,
            openingPrice: 54930.76,
            closingPrice: 54932.06),
        Candle(
            timestamp: DateTime.fromMicrosecondsSinceEpoch(1633780800),
            lowestPrice: 54700.0,
            highestPrice: 55500.0,
            openingPrice: 54810.33,
            closingPrice: 54930.76),
        Candle(
            timestamp: DateTime.fromMicrosecondsSinceEpoch(1633759200),
            lowestPrice: 54504.94,
            highestPrice: 55348.27,
            openingPrice: 54608.3,
            closingPrice: 54806.4),
        Candle(
            timestamp: DateTime.fromMicrosecondsSinceEpoch(1633737600),
            lowestPrice: 53675.0,
            highestPrice: 54761.01,
            openingPrice: 53965.18,
            closingPrice: 54600.63),
        Candle(
            timestamp: DateTime.fromMicrosecondsSinceEpoch(1633716000),
            lowestPrice: 53786.29,
            highestPrice: 54782.71,
            openingPrice: 54311.37,
            closingPrice: 53963.82),
        Candle(
            timestamp: DateTime.fromMicrosecondsSinceEpoch(1633694400),
            lowestPrice: 54023.49,
            highestPrice: 55336.3,
            openingPrice: 55264.97,
            closingPrice: 54311.82),
        Candle(
            timestamp: DateTime.fromMicrosecondsSinceEpoch(1633672800),
            lowestPrice: 54015.97,
            highestPrice: 56113.0,
            openingPrice: 54190.65,
            closingPrice: 55264.03),
        Candle(
            timestamp: DateTime.fromMicrosecondsSinceEpoch(1633651200),
            lowestPrice: 53634.41,
            highestPrice: 54438.35,
            openingPrice: 53805.46,
            closingPrice: 54189.19),
      ]);
}

/// A [Prices] getter actually connected to the Coinbase Pro API.
class CoinbaseProPrices extends Prices {
  @override
  Future<Dollars> currentPrice({required Currency of}) async {
    final String from = of.callLetters;
    final String to = Currencies.dollars.callLetters;
    if (from == to) return Dollars(1);
    final String path = 'products/$from-$to/ticker';
    final String apiResponse = await CoinbaseApi().get(path: path);
    final priceStr = jsonDecode(apiResponse)['price'] as String;
    final double price = double.parse(priceStr);
    return Dollars(price);
  }

  @override
  Future<List<Candle>> candles(Currency currency) async {
    final String rawResponse = await CoinbaseApi().candles(currency);
    final parsed = jsonDecode(rawResponse) as List<dynamic>;
    return parsed.map((e) => Candle.fromCoinbase(e)).toList();
  }
}

/// Price fluctuations for one [Currency] for one "duration".
class Candle {
  /// Price fluctuations for one [Currency] for one "duration".
  const Candle({
    required this.timestamp,
    required this.lowestPrice,
    required this.highestPrice,
    required this.openingPrice,
    required this.closingPrice,
  });

  /// Parse Coinbase response into a [Candle].
  factory Candle.fromCoinbase(dynamic input) => Candle(
        timestamp:
            DateTime.fromMicrosecondsSinceEpoch((input[0] as num).toInt()),
        lowestPrice: (input[1] as num).toDouble(),
        highestPrice: (input[2] as num).toDouble(),
        openingPrice: (input[3] as num).toDouble(),
        closingPrice: (input[4] as num).toDouble(),
      );

  /// Start time of the period.
  final DateTime timestamp;

  /// Lowest price in this time interval.
  final double lowestPrice;

  /// Highest price in this time interval.
  final double highestPrice;

  /// Opening price in this time interval.
  final double openingPrice;

  /// Closing price in this time interval.
  final double closingPrice;

  @override
  String toString() => 'Candle('
      'timestamp: $timestamp, '
      'priceLow: $lowestPrice, '
      'priceHigh: $highestPrice, '
      'priceOpen: $openingPrice, '
      'priceClose: $closingPrice'
      ')';
}
