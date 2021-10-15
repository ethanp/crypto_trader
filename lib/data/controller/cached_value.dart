import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:synchronized/synchronized.dart';

/// Holds a remote value in local cache for the duration of the program.
abstract class CachedValue<T> {
  T? _cachedValue;
  final _synchronizer = Lock(reentrant: true);

  /// Retrieve the item from cache if it exists, otherwise download
  /// and cache it.
  Future<T> get() async {
    await _synchronizer.synchronized(() async {
      if (_cachedValue != null) {
        print('Not refreshing cache');
      } else {
        print('Refreshing cache');
        _cachedValue = await _retrieve();
        print('Refilled cache $_cachedValue');
      }
    });
    return Future.value(_cachedValue);
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
}
