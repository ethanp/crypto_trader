import 'dart:convert';

import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

abstract class Trader extends ChangeNotifier {
  final HoldingsCache _holdingsCache = new HoldingsCache();

  final _synchronizer = new Lock(reentrant: true);

  Future<Dollars> getMyEarnings() async {
    final Holdings holdings = await getMyHoldings();
    final Dollars deposits = await getTotalDeposits();
    return holdings.totalValue - deposits;
  }

  Future<Dollars> getTotalDeposits();

  Future<Holdings> getMyHoldings() =>
      _synchronizer.synchronized(_holdingsCache.get);

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

  Future<void> invalidateHoldings() =>
      _synchronizer.synchronized(_holdingsCache.invalidate);

  Future<void> forceRefreshHoldings() async {
    await invalidateHoldings();
    await getMyHoldings();
  }
}

class FakeTrader extends Trader {
  Dollars spending = Dollars(10);

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
  Future<Dollars> getTotalDeposits() => Future.value(spending);
}

class CoinbaseProTrader extends Trader {
  /// https://docs.pro.coinbase.com/?ruby#place-a-new-order
  @override
  Future<String> spendInternal(Holding order) async {
    final String orderResponse = await CoinbaseApi().marketOrder(order);
    print('Order: $orderResponse');
    final dynamic decoded = jsonDecode(orderResponse);
    await invalidateHoldings();
    return decoded['id'] as String;
  }

  @override
  Future<String> depositInternal(Dollars dollars) async {
    final String depositResponse = await CoinbaseApi().deposit(dollars);
    print('Deposit: $depositResponse');
    final dynamic decoded = jsonDecode(depositResponse);
    await invalidateHoldings();
    return decoded['id'] as String;
  }

  @override
  Future<Dollars> getTotalDeposits() => CoinbaseApi().totalDeposits();
}
