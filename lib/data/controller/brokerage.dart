import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/util.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

/// Enables trading cryptocurrencies.
abstract class Brokerage extends ChangeNotifier {
  final HoldingsCache _holdingsCache = HoldingsCache();

  /// Makes it so that one spend() or deposit() can be active at a time.
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
  Future<void> _spendInternal(Holding holding);

  @protected
  Future<void> _depositInternal(Dollars dollars);

  Future<void> purchaseOrder(Holding purchaseOrder) =>
      _synchronizer.synchronized(() async {
        var dollars = purchaseOrder.dollarValue;
        final currency = purchaseOrder.currency;
        print('Buying $dollars of $currency');
        try {
          // `await` makes the exception "catchable".
          return await _spendInternal(Holding(
            currency: currency,
            dollarValue: dollars,
          ));
        } on InsufficientFundsException {
          // Sometimes insufficient funds is due to rounding error or something,
          // so it works if we just try 1 cent less.
          dollars -= Dollars(0.01);
          print('Insufficient funds trying $dollars of $currency');
          await _spendInternal(Holding(
            currency: currency,
            dollarValue: dollars,
          ));
          _invalidateHoldings();
        }
      });

  /// Trade USD for the "shortest" currency. Ie. the one where we have the
  /// largest deficit compared to its portfolio allocation.
  Future<void> spend(Dollars dollars) =>
      _synchronizer.synchronized(() async => purchaseOrder(Holding(
          currency: (await getMyHoldings()).shortest.currency,
          dollarValue: dollars)));

  /// Deposit [dollars] into brokerage account from linked checking account.
  Future<void> deposit(Dollars dollars) => _synchronizer.synchronized(() async {
        print('Depositing $dollars');
        await _depositInternal(dollars);
        _invalidateHoldings();
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
    print('Fake-buying ${holding.dollarValue} of ${holding.currency.name}');
    final holdings = await getMyHoldings();
    // Seems ok to violate the "dot-dot principle" here since it's a fake :)
    final Dollars to = holdings.of(holding.currency);
    final Dollars from = holdings.of(Currencies.dollars);
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
    holdings.of(Currencies.dollars).amt += deposit.amt;
    return 'Succeeded';
  }

  @override
  Future<Dollars> _getTotalDeposits() => Future.value(_spending);
}

/// Trade cryptocurrencies on Coinbase Pro, via the [CoinbaseApi].
class CoinbaseProBrokerage extends Brokerage {
  /// https://docs.pro.coinbase.com/?ruby#place-a-new-order
  @override
  Future<void> _spendInternal(Holding order) =>
      CoinbaseApi().marketOrder(order);

  @override
  Future<void> _depositInternal(Dollars dollars) =>
      CoinbaseApi().deposit(dollars);

  @override
  Future<Dollars> _getTotalDeposits() => CoinbaseApi().totalDeposits();
}
