import 'dart:convert';

import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

/// Enables trading cryptocurrencies.
abstract class Brokerage extends ChangeNotifier {
  final HoldingsCache _holdingsCache = HoldingsCache();

  final _synchronizer = Lock(reentrant: true);

  /// Earnings = Holdings - Deposits.
  Future<Dollars> getMyEarnings() async {
    final Holdings holdings = await getMyHoldings();
    final Dollars deposits = await _getTotalDeposits();
    return holdings.totalValue - deposits;
  }

  Future<Dollars> _getTotalDeposits();

  /// Retrieve [Holdings], possibly from cache.
  Future<Holdings> getMyHoldings() =>
      _synchronizer.synchronized(_holdingsCache.get);

  @protected
  Future<String> _spendInternal(Holding holding);

  @protected
  Future<String> _depositInternal(Dollars dollars);

  /// Trade USD for the "shortest" currency. Ie. the one where we have the
  /// largest deficit compared to its portfolio allocation.
  Future<String> spend(Dollars dollars) => _synchronizer.synchronized(() async {
        print('Spending $dollars');
        return _spendInternal(Holding(
          currency: (await getMyHoldings()).shortest.currency,
          dollarValue: dollars,
        ));
      });

  /// Deposit [dollars] into brokerage account from linked checking account.
  Future<String> deposit(Dollars dollars) =>
      _synchronizer.synchronized(() async {
        print('Depositing $dollars');
        return _depositInternal(dollars);
      });

  Future<void> _invalidateHoldings() =>
      _synchronizer.synchronized(_holdingsCache.invalidate);

  /// Retrieve [Holdings] from remote source and cache new response.
  Future<Holdings> forceRefreshHoldings() async {
    await _invalidateHoldings();
    return getMyHoldings();
  }
}

class FakeBrokerage extends Brokerage {
  Dollars _spending = Dollars(10);

  @override
  Future<String> _spendInternal(Holding holding) async {
    print('Fake-buying ${holding.asPurchaseStr}');
    final holdings = await getMyHoldings();
    // Seems ok to violate the "dot-dot principle" here since it's a fake :)
    final Dollars to = holdings.dollarsOf(holding.currency);
    final Dollars from = holdings.dollarsOf(Currencies.dollars);
    // Use .amt because we're actually mutating the `holdings` map here.
    to.amt += holding.dollarValue.amt;
    from.amt -= holding.dollarValue.amt;
    // Here we're just reassigning the field.
    _spending += holding.dollarValue;
    return 'Succeeded';
  }

  @override
  Future<String> _depositInternal(Dollars deposit) async {
    print('Fake-transferring $deposit from Schwab');
    final holdings = await getMyHoldings();
    holdings.dollarsOf(Currencies.dollars).amt += deposit.amt;
    return 'Succeeded';
  }

  @override
  Future<Dollars> _getTotalDeposits() => Future.value(_spending);
}

/// Trade cryptocurrencies on Coinbase Pro, via the [CoinbaseApi].
class CoinbaseProBrokerage extends Brokerage {
  /// https://docs.pro.coinbase.com/?ruby#place-a-new-order
  @override
  Future<String> _spendInternal(Holding order) async {
    final String orderResponse = await CoinbaseApi().marketOrder(order);
    print('Order: $orderResponse');
    final dynamic decoded = jsonDecode(orderResponse);
    await _invalidateHoldings();
    return decoded['id'] as String;
  }

  @override
  Future<String> _depositInternal(Dollars dollars) async {
    final String depositResponse = await CoinbaseApi().deposit(dollars);
    print('Deposit: $depositResponse');
    final dynamic decoded = jsonDecode(depositResponse);
    await _invalidateHoldings();
    return decoded['id'] as String;
  }

  @override
  Future<Dollars> _getTotalDeposits() => CoinbaseApi().totalDeposits();
}
