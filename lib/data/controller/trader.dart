import 'dart:convert';

import 'package:crypto_trader/data/access/coinbase_api.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

abstract class Trader extends ChangeNotifier {
  // TODO(low priority): Cache expiration.
  Holdings? _holdingsCache;
  bool _cacheValid = false;

  final _synchronizer = new Lock(reentrant: true);

  Future<Dollars> getMyEarnings() async {
    final holdings = await getMyHoldings();
    final spendings = await getMySpending();
    return holdings.totalValue - spendings;
  }

  Future<Dollars> getMySpending();

  Future<Holdings> getMyHoldings() async {
    await _synchronizer.synchronized(() async {
      var shouldRefreshCache = !_cacheValid || _holdingsCache == null;
      if (!shouldRefreshCache)
        print('Not refreshing holdings cache');
      else {
        var debugStr = 'REFRESHING holdings cache! ';
        if (!_cacheValid) debugStr += 'cache was invalidated';
        if (_holdingsCache == null) {
          if (!_cacheValid) debugStr += ' AND ';
          debugStr += 'cache was null';
        }
        print(debugStr);
        _holdingsCache = await holdingsInternal();
        _cacheValid = true;
        print('Refilled holdings cache $_holdingsCache');
      }
    });
    return Future.value(_holdingsCache);
  }

  @protected
  Future<Holdings> holdingsInternal();

  @protected
  Future<String> spendInternal(Holding holding);

  @protected
  Future<String> depositInternal(Dollars dollars);

  Future<String> spend(Dollars dollars) async =>
      await _synchronizer.synchronized(() async {
        print('Spending $dollars');
        return spendInternal(
          Holding(
            currency: (await getMyHoldings()).shortest.currency,
            dollarValue: dollars,
          ),
        );
      });

  Future<String> deposit(Dollars dollars) async =>
      await _synchronizer.synchronized(() async {
        print('Depositing $dollars');
        return depositInternal(dollars);
      });

  // TODO for some reason this isn't working at all.
  //  • Maybe the debugger would help?
  //  • Maybe registering for UI refreshes on the widgets whose data actually
  //    changes would fix it, instead of only registering the top-level Widget.
  Future<void> invalidateHoldings() async =>
      await _synchronizer.synchronized(() => _cacheValid = false);

  Future<void> forceRefreshHoldings() async {
    if (_cacheValid) await invalidateHoldings();
    await getMyHoldings();
  }
}

class FakeTrader extends Trader {
  Dollars spending = Dollars(10);

  @override
  Future<Holdings> holdingsInternal() => Future.value(Holdings.random());

  @override
  Future<String> spendInternal(Holding holding) async {
    print('Fake-buying ${holding.asPurchaseStr}');
    final holdings = await getMyHoldings();
    // Seems ok to violate the "dot-dot principle" here since it's a fake :)
    final Dollars to = holdings.dollarsOf(holding.currency);
    final Dollars from = holdings.dollarsOf(Currencies.dollars);
    // Use .amt because we're actually mutating the `holdings` map here.
    to.amt += holding.dollarValue.amt;
    from.amt -= holding.dollarValue.amt;
    // Here we're just reassigning the field.
    spending += holding.dollarValue;
    return 'Succeeded';
  }

  @override
  Future<String> depositInternal(Dollars deposit) async {
    print('Fake-transferring $deposit from Schwab');
    final holdings = await getMyHoldings();
    holdings.dollarsOf(Currencies.dollars).amt += deposit.amt;
    return 'Succeeded';
  }

  @override
  Future<Dollars> getMySpending() => Future.value(spending);
}

class CoinbaseProTrader extends Trader {
  /// Calls https://docs.pro.coinbase.com/?ruby#list-accounts
  @override
  Future<Holdings> holdingsInternal() async {
    final String holdingsResponse =
        await CoinbaseApi().get(path: '/accounts', private: true);
    final List<dynamic> accountListRaw = jsonDecode(holdingsResponse);
    return Holdings(await Future.wait(accountListRaw
        .map((raw) => CoinbaseAccount(raw))
        .where((acct) => acct.isSupported)
        .map((acct) => acct.asHolding)));
  }

  /// https://docs.pro.coinbase.com/?ruby#place-a-new-order
  @override
  Future<String> spendInternal(Holding order) async {
    final String orderResponse = await CoinbaseApi().marketOrder(order);
    print('Order: $orderResponse');
    final Map<String, dynamic> decoded = jsonDecode(orderResponse);
    await invalidateHoldings();
    return decoded['id'];
  }

  @override
  Future<String> depositInternal(Dollars dollars) async {
    final String depositResponse = await CoinbaseApi().deposit(dollars);
    print('Deposit: $depositResponse');
    final Map<String, dynamic> decoded = jsonDecode(depositResponse);
    await invalidateHoldings();
    return decoded['id'];
  }

  @override
  Future<Dollars> getMySpending() async {
    final String ordersResponse = await CoinbaseApi().orders();
    // TODO: implement getMySpending
    throw UnimplementedError();
  }
}
