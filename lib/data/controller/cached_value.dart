import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:synchronized/synchronized.dart';

abstract class CachedValue<T> {
  T? _cache;
  final _synchronizer = new Lock(reentrant: true);

  Future<T> get() async {
    await _synchronizer.synchronized(() async {
      var shouldRefreshCache = _cache == null;
      if (!shouldRefreshCache)
        print('Not refreshing cache');
      else {
        print('Refreshing cache');
        _cache = await internal();
        print('Refilled cache $_cache');
      }
    });
    return Future.value(_cache);
  }

  Future<void> invalidate() => _synchronizer.synchronized(() => _cache = null);

  Future<T> internal();
}

class HoldingsCache extends CachedValue<Holdings> {
  @override
  Future<Holdings> internal() =>
      Environment.fake ? fakeInternal() : coinbaseInternal();

  Future<Holdings> fakeInternal() => Future.value(Holdings.random());

  Future<Holdings> coinbaseInternal() async {
    /// Calls https://docs.pro.coinbase.com/?ruby#list-accounts
    final accounts = await CoinbaseApi().getAccounts();
    return Holdings(await Future.wait(accounts
        .where((acct) => acct.isSupported)
        .map((acct) => acct.asHolding)));
  }
}
