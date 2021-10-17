import 'package:crypto_trader/data/access/coinbase_api.dart';
import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';

/// Interface for retrieving price data from external sources.
abstract class PriceSource {
  // TODO cache individually at each Granularity.
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
  Future<Dollars> currentPrice({required Currency of}) =>
      CoinbaseApi().currentPrice(of: of);
}
