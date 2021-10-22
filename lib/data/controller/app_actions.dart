import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

/*
 * TODO Finish this. Still haven't quite figured out how it's gonna work.
 *  Could be best to start out with a design doc.
 *  See diagram in https://lucid.app/lucidchart/6b93f504-d4fe-4678-ac79-7367588f256f/edit?invitationId=inv_b2451dd2-8c3a-4353-8815-b600572ba92d
 */

/// Runs one [MultistageAction] at a time, and will [notifyListeners()] when
/// the [_MultistageActionState] changes.
class MultistageActionExecutor extends ChangeNotifier {
  final _synchronizer = Lock(reentrant: true);

  Future<List<void>> add(MultistageAction action) =>
      _synchronizer.synchronized(() {
        print('starting $action');
        return Future.wait([_onAdd(action)]);
      });

  Future<void> _onAdd(MultistageAction action) async {
    // If the _actions queue wasn't empty, it will have an action that was
    // already executing.
    if (action._state == _MultistageActionState.scheduled) {
      action._state = _MultistageActionState.requesting;
      notifyListeners();
      await (action.request()).onError(
          (error, stackTrace) => action._state = _MultistageActionState.error);
      if (action.state == _MultistageActionState.error) {
        print('Error case 1');
        notifyListeners();
        return;
      }
      action._state = _MultistageActionState.verifying;
      notifyListeners();
      await action.verify().onError(
          (error, stackTrace) => action._state = _MultistageActionState.error);
      if (action.state == _MultistageActionState.error) {
        print('Error case 2');
        notifyListeners();
        return;
      }
      print('success case');
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
