// TODO Finish this. Still haven't quite figured out how it's gonna work.
//  Could be best to start out with a design doc.
//  See diagram in https://lucid.app/lucidchart/6b93f504-d4fe-4678-ac79-7367588f256f/edit?invitationId=inv_b2451dd2-8c3a-4353-8815-b600572ba92d
import 'dart:collection';

import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:flutter/material.dart';

class DepositAction extends AppAction {
  DepositAction(this.amount);

  final Dollars amount;
  late final Holdings holdingsCopy;

  @override
  Future<void> request() async {
    holdingsCopy = (await Environment.trader.getMyHoldings()).copy();
    await Environment.trader.deposit(amount);
  }

  @override
  Future<void> verify() async {
    int numRuns = 0;
    while (numRuns++ < 6) {
      await Future.delayed(const Duration(seconds: 2));
      final holdings = await Environment.trader.forceRefreshHoldings();
      if (holdings != holdingsCopy) return;
    }
    throw StateError('Operation timed out');
  }
}

enum _ActionState {
  scheduled,
  requesting,
  verifying,
  completeWithoutError,
  error,
}

abstract class AppAction {
  var state = _ActionState.scheduled;

  Future<void> request();

  Future<void> verify();
}

// TODO probably needs a synchronization lock.
class Executor extends ChangeNotifier {
  final _actions = Queue<AppAction>();

  void add(AppAction action) {
    _actions.addLast(action);
    _onAdd();
  }

  Future<void> _onAdd() async {
    if (_actions.first.state == _ActionState.scheduled) {
      _actions.first.state = _ActionState.requesting;
      await _actions.first.request();
      notifyListeners();
    }
  }
}
