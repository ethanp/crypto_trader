import 'dart:async';

import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';

import 'command.dart';

abstract class TransactCommand extends MultistageCommand {
  TransactCommand(this.fun);

  final Future<void> Function() fun;
  late final Dollars _originalDollarsHolding;

  @override
  Future<void> request() async {
    _originalDollarsHolding = await _dollarsNow();
    print('Original dollars: $_originalDollarsHolding');
    await fun();
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
  DepositCommand(this.amount)
      : super(() async => Environment.trader.deposit(amount));

  final Dollars amount;

  @override
  String get title => 'Depositing dollars';

  @override
  String get subtitle => amount.toString();
}

class SpendCommand extends TransactCommand {
  SpendCommand(this.amount)
      : super(() async => Environment.trader.spend(amount));
  final Dollars amount;

  @override
  String get title => 'Buying crypto';

  @override
  String get subtitle => amount.toString();
}

class PurchaseCommand extends TransactCommand {
  PurchaseCommand(this.purchaseOrder)
      : super(() async => Environment.trader.purchaseOrder(purchaseOrder));

  final Holding purchaseOrder;

  @override
  String get title => 'Buying ${purchaseOrder.currency}';

  @override
  String get subtitle => purchaseOrder.dollarValue.toString();
}
