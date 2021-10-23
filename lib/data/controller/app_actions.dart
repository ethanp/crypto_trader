import 'dart:async';

import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

/// Runs one [MultistageAction] at a time, and will [notifyListeners()] when
/// the [MultistageActionState] changes.
///
/// This class is testable using $BASE_DIR/lib/app_actions_trial/main.dart.
class MultistageActionExecutor extends ChangeNotifier {
  final _synchronizer = Lock(reentrant: true);

  /// Only useful for debugging this class.
  MultistageAction? currAction;

  MultistageActionState get state =>
      currAction?.state ?? MultistageActionState.nonExistent;

  // This synchronization turns this Executor into an implicit Queue ADT.
  Future<void> add(MultistageAction action) =>
      _synchronizer.synchronized(() async {
        print('starting $action');
        currAction = action;
        await _request(action);
        await _verify(action);
        _complete(action);
      });

  bool get isRunning => [
        MultistageActionState.scheduled,
        MultistageActionState.requesting,
        MultistageActionState.verifying
      ].contains(state);

  Future<void> _request(MultistageAction action) async {
    // See https://dart.dev/codelabs/async-await#handling-errors
    try {
      action._state = MultistageActionState.requesting;
      notifyListeners();
      await action.request();
    } on Exception catch (e) {
      action._state = MultistageActionState.errorDuringRequest;
      action.error = e;
      print('Error during request phase of $action');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _verify(MultistageAction action) async {
    try {
      action._state = MultistageActionState.verifying;
      notifyListeners();
      await action.verify();
    } on Exception catch (e) {
      action._state = MultistageActionState.errorDuringVerify;
      action.error = e;
      print('Error during verify phase of $action');
      notifyListeners();
      rethrow;
    }
  }

  void _complete(MultistageAction action) {
    print('$action action succeeded');
    action._state = MultistageActionState.success;
    notifyListeners();
  }
}

abstract class MultistageAction {
  var _state = MultistageActionState.scheduled;

  // Clarification on terminology:
  //
  // [Exception] = the standard Dart term for a non-terminal failure condition
  //
  // "error"     = standard English term denoting something that went wrong
  //               during an operation
  //
  Exception? error;

  MultistageActionState get state => _state;

  Future<void> request();

  Future<void> verify();

  @override
  String toString() => '$runtimeType{_state: $_state}';
}

enum MultistageActionState {
  nonExistent,
  scheduled,
  requesting,
  verifying,
  success,
  errorDuringRequest,
  errorDuringVerify,
}

class TransactAction extends MultistageAction {
  TransactAction(this.amount, this.fun);

  final Future<String> Function(Dollars) fun;
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
    for (int numRuns = 0; numRuns < 6; numRuns++) {
      await Future.delayed(const Duration(seconds: 2));
      final dollarsNow = await _dollarsNow();
      if (dollarsNow != _originalDollarsHolding) {
        print('Updated dollars: $dollarsNow');
        return;
      }
      print('Deposited amount has not been received yet');
    }
    throw TimeoutException('$this timed out');
  }

  Future<Dollars> _dollarsNow() async {
    final holdings = await Environment.trader.forceRefreshHoldings();
    final dollarsNow = holdings.dollarsOf(Currencies.dollars);
    return dollarsNow;
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
