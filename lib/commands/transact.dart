import 'dart:async';

import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';

import 'command.dart';

abstract class TransactCommand extends MultistageCommand {
  TransactCommand(this.amount, this.fun);

  final Future<void> Function(Dollars) fun;
  final Dollars amount;
  late final Dollars _originalDollarsHolding;

  @override
  Future<void> request() async {
    _originalDollarsHolding = await _dollarsNow();
    print('Original dollars: $_originalDollarsHolding');
    await fun(amount);
  }

  @override
  Future<void> verify() async {
    for (int numRuns = 0; numRuns < 10; numRuns++) {
      await Future.delayed(const Duration(seconds: 1));
      final dollarsNow = await _dollarsNow();
      if (dollarsNow != _originalDollarsHolding) {
        print('Updated dollars: $dollarsNow');
        return;
      }
      print('Updated account balances have not been received yet');
    }
    throw TimeoutException('$this timed out');
  }

  Future<Dollars> _dollarsNow() async {
    final holdings = await Environment.trader.forceRefreshHoldings();
    final dollarsNow = holdings.of(Currencies.dollars);
    return dollarsNow;
  }
}

class DepositCommand extends TransactCommand {
  DepositCommand(Dollars amount) : super(amount, Environment.trader.deposit);

  @override
  String get title => 'Depositing dollars';
}

class SpendCommand extends TransactCommand {
  SpendCommand(Dollars amount) : super(amount, Environment.trader.spend);

  @override
  String get title => 'Buying crypto';
}

class PurchaseCommand extends TransactCommand {
  // TODO(feature): This is currently a fake implementation that devolves to the
  //  older version. It should be calling the Environment.trader.purchase API
  //  (yet-to-be-built).
  PurchaseCommand(this.purchaseOrder)
      : super(purchaseOrder.dollarValue, Environment.trader.spend);

  final Holding purchaseOrder;

  @override
  String get title => 'Buying ${purchaseOrder.debugString()}';
}
