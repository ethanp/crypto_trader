import 'dart:convert';

import 'package:crypto_trader/data/access/granularity.dart';
import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:synchronized/synchronized.dart';

/// Holds a remote value in local cache for the duration of the program.
abstract class CachedValue<T> {
  T? _cachedValue;
  final _synchronizer = Lock(reentrant: true);

  /// Retrieve the item from cache if it exists,
  /// Otherwise download and cache it.
  Future<T> get() async {
    await _synchronizer.synchronized(() async {
      if (_cachedValue == null) {
        print('Refreshing $this');
        _cachedValue = await _retrieve();
        print('Refilled cache $this');
      }
    });
    return _cachedValue!;
  }

  /// Clear the cache, so that the value is re-downloaded next time it is used.
  Future<void> invalidate() =>
      _synchronizer.synchronized(() => _cachedValue = null);

  /// Download the item.
  Future<T> _retrieve();
}

/// Stores cached version of [Holdings].
class HoldingsCache extends CachedValue<Holdings> {
  @override
  Future<Holdings> _retrieve() =>
      Environment.fake ? _fakeInternal() : _coinbaseInternal();

  Future<Holdings> _fakeInternal() => Future.value(Holdings.random());

  Future<Holdings> _coinbaseInternal() async {
    /// Calls https://docs.pro.coinbase.com/?ruby#list-accounts
    final accounts = await CoinbaseApi().getAccounts();
    return Holdings(await Future.wait(accounts
        .where((acct) => acct.isSupported)
        .map((acct) => acct.asHolding)));
  }

  @override
  String toString() => 'HoldingsCache';
}

/// Stored cached list of [Candle]s for a [currency].
class CandlesCache extends CachedValue<List<Candle>> {
  /// Stored cached list of [Candle]s for a [currency] and [granularity].
  CandlesCache(this.currency, this.granularity);

  final Currency currency;
  final Granularity granularity;

  @override
  String toString() =>
      'CandlesCache{currency: $currency, granularity: $granularity}';

  @override
  Future<List<Candle>> _retrieve() =>
      Environment.fake ? _fakeInternal() : _coinbaseInternal();

  Future<List<Candle>> _fakeInternal() => Future.value(_fakeCandles);

  Future<List<Candle>> _coinbaseInternal() async {
    final String rawResponse =
        await CoinbaseApi().candles(currency, granularity);
    final parsed = jsonDecode(rawResponse) as List<dynamic>;
    return parsed.map((e) => Candle.fromCoinbase(e)).toList();
  }
}

DateTime _sec(int sec) => DateTime.fromMillisecondsSinceEpoch(sec * 1000);
final _fakeCandles = [
  Candle(
      timestamp: _sec(1633802400),
      lowestPrice: 54345.08,
      highestPrice: 55167.15,
      openingPrice: 54930.76,
      closingPrice: 54932.06),
  Candle(
      timestamp: _sec(1633780800),
      lowestPrice: 54700.0,
      highestPrice: 55500.0,
      openingPrice: 54810.33,
      closingPrice: 54930.76),
  Candle(
      timestamp: _sec(1633759200),
      lowestPrice: 54504.94,
      highestPrice: 55348.27,
      openingPrice: 54608.3,
      closingPrice: 54806.4),
  Candle(
      timestamp: _sec(1633737600),
      lowestPrice: 53675.0,
      highestPrice: 54761.01,
      openingPrice: 53965.18,
      closingPrice: 54600.63),
  Candle(
      timestamp: _sec(1633716000),
      lowestPrice: 53786.29,
      highestPrice: 54782.71,
      openingPrice: 54311.37,
      closingPrice: 53963.82),
  Candle(
      timestamp: _sec(1633694400),
      lowestPrice: 54023.49,
      highestPrice: 55336.3,
      openingPrice: 55264.97,
      closingPrice: 54311.82),
  Candle(
      timestamp: _sec(1633672800),
      lowestPrice: 54015.97,
      highestPrice: 56113.0,
      openingPrice: 54190.65,
      closingPrice: 55264.03),
  Candle(
      timestamp: _sec(1633651200),
      lowestPrice: 53634.41,
      highestPrice: 54438.35,
      openingPrice: 53805.46,
      closingPrice: 54189.19),
];
