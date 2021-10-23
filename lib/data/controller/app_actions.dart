import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

/// Runs one [MultistageAction] at a time, and will [notifyListeners()] when
/// the [_MultistageActionState] changes.
///
/// This class is testable using $BASE_DIR/lib/app_actions_trial/main.dart.
class MultistageActionExecutor extends ChangeNotifier {
  final _synchronizer = Lock(reentrant: true);
  MultistageAction? currAction;

  // This synchronization turns this Executor into an implicit Queue ADT.
  Future<void> add(MultistageAction action) => _synchronizer.synchronized(() {
        print('starting $action');
        currAction = action;
        return _onAdd();
      });

  Future<void> _onAdd() async {
    final action = currAction!;
    if (action._state == _MultistageActionState.scheduled) {
      action._state = _MultistageActionState.requesting;
      notifyListeners();
      // Docs for this: https://dart.dev/codelabs/async-await#handling-errors
      try {
        await action.request();
      } on Exception {
        action._state = _MultistageActionState.error;
        print('Error during request phase of $action');
        notifyListeners();
        rethrow;
      }
      action._state = _MultistageActionState.verifying;
      notifyListeners();
      try {
        await action.verify();
      } on Exception {
        action._state = _MultistageActionState.error;
        print('Error during verify phase of $action');
        notifyListeners();
        rethrow;
      }
      print('$action action succeeded');
      action._state = _MultistageActionState.completeWithoutError;
      notifyListeners();
    }
  }
}

abstract class MultistageAction {
  var _state = _MultistageActionState.scheduled;

  get state => _state;

  Future<void> request();

  Future<void> verify();

  @override
  String toString() => '$runtimeType{_state: $_state}';
}

enum _MultistageActionState {
  scheduled,
  requesting,
  verifying,
  completeWithoutError,
  error,
}

class DepositAction extends MultistageAction {
  DepositAction(this.amount);

  final Dollars amount;
  late final Dollars _originalDollarsHolding;

  @override
  Future<void> request() async {
    // TODO catch errors (thrown at the bottom) here.
    final holdings = await Environment.trader.getMyHoldings();
    _originalDollarsHolding = holdings.dollarsOf(Currencies.dollars);
    // TODO catch errors (thrown at the bottom) here.
    await Environment.trader.deposit(amount);
  }

  @override
  Future<void> verify() async {
    int numRuns = 0;
    while (numRuns++ < 6) {
      await Future.delayed(const Duration(seconds: 2));
      // TODO catch errors (thrown at the bottom) here.
      final holdings = await Environment.trader.forceRefreshHoldings();
      final dollarsNow = holdings.dollarsOf(Currencies.dollars);
      if (dollarsNow != _originalDollarsHolding) {
        _state = _MultistageActionState.completeWithoutError;
      }
    }
    throw StateError('Operation timed out');
  }
}

class FakeAction extends MultistageAction {
  @override
  Future<void> request() {
    return Future.delayed(const Duration(seconds: 1), () {
      print('$runtimeType request()');
    });
  }

  @override
  Future<void> verify() {
    return Future.delayed(const Duration(seconds: 1), () {
      print('$runtimeType verify()');
    });
  }
}

class ErrantRequestAction extends MultistageAction {
  @override
  Future<void> request() {
    return Future.delayed(const Duration(seconds: 1), () {
      throw Exception('error from $runtimeType#request()');
    });
  }

  @override
  Future<void> verify() {
    return Future.delayed(const Duration(seconds: 1), () {
      print('ERROR: Should not have gotten here in $runtimeType');
    });
  }
}

class ErrantVerifyAction extends MultistageAction {
  @override
  Future<void> request() {
    return Future.delayed(const Duration(seconds: 1), () {
      print('$runtimeType request()');
    });
  }

  @override
  Future<void> verify() {
    return Future.delayed(const Duration(seconds: 1), () {
      throw Exception('error from $runtimeType#verify()');
    });
  }
}
