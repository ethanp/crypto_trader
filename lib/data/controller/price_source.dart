import 'package:crypto_trader/data/access/granularity.dart';
import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';

/// Interface for retrieving price data from external sources.
abstract class PriceSource {
  final CandleCaches _candlesCaches = CandleCaches.build();

  /// The current price of [Currency] [of] in [Dollars].
  Future<Dollars> currentPrice({required Currency of});

  /// Historical price data for [currency].
  Future<List<Candle>> candles(Currency currency, Granularity granularity) =>
      _candlesCaches.get(currency, granularity);

  void forceRefresh() => _candlesCaches.invalidate();
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

class CandleCaches {
  const CandleCaches._(this._caches);

  factory CandleCaches.build() => CandleCaches._({
        for (final c in Currencies.crypto)
          c: {for (final g in Granularities.all) g: CandlesCache(c, g)}
      });

  final Map<Currency, Map<Granularity, CandlesCache>> _caches;

  Future<List<Candle>> get(Currency currency, Granularity granularity) =>
      _caches[currency]![granularity]!.get();

  void invalidate() => Future.wait(
      _caches.values.expand((e1) => e1.values.map((e2) => e2.invalidate())));
}
