import 'dart:convert';

import 'package:crypto_trader/data/access/coinbase_api.dart';
import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';

/// Interface for retrieving price data from external sources.
abstract class PriceSource {
  final List<CandlesCache> _candlesCaches = Currencies.allCryptoCurrencies
      .map((c) => CandlesCache(currency: c))
      .toList();

  /// The current price of [Currency] [of] in [Dollars].
  Future<Dollars> currentPrice({required Currency of});

  /// Historical price data for [currency].
  Future<List<Candle>> candles(Currency currency) =>
      _candlesCaches.firstWhere((cache) => cache.currency == currency).get();
}

/// A [PriceSource] getter with fake data.
class FakePriceSource extends PriceSource {
  @override
  Future<Dollars> currentPrice({required Currency of}) =>
      Future.value(Dollars(100));
}

/// A [PriceSource] getter actually connected to the Coinbase Pro API.
class CoinbaseProPriceSource extends PriceSource {
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
      'priceClose: $closingPrice)';
}
