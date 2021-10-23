import 'dart:async';

import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

/// Runs one [MultistageCommand] at a time, and will [notifyListeners()] when
/// the [MultistageCommandState] changes.
///
/// This class is testable using $BASE_DIR/lib/app_actions_trial/main.dart.
class MultistageCommandExecutor extends ChangeNotifier {
  final _synchronizer = Lock(reentrant: true);

  /// Only useful for debugging this class.
  MultistageCommand? currCommand;

  MultistageCommandState get state =>
      currCommand?.state ?? MultistageCommandState.nonExistent;

  // This synchronization turns this Executor into an implicit Queue ADT.
  Future<void> add(MultistageCommand command) =>
      _synchronizer.synchronized(() async {
        print('starting $command');
        currCommand = command;
        await _request(command);
        await _verify(command);
        _complete(command);
      });

  bool get isRunning => [
        MultistageCommandState.scheduled,
        MultistageCommandState.requesting,
        MultistageCommandState.verifying
      ].contains(state);

  Future<void> _request(MultistageCommand command) async {
    // See https://dart.dev/codelabs/async-await#handling-errors
    try {
      command._state = MultistageCommandState.requesting;
      notifyListeners();
      await command.request();
    } on Exception catch (e) {
      command._state = MultistageCommandState.errorDuringRequest;
      command.error = e;
      print('Error during request phase of $command');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _verify(MultistageCommand command) async {
    try {
      command._state = MultistageCommandState.verifying;
      notifyListeners();
      await command.verify();
    } on Exception catch (e) {
      command._state = MultistageCommandState.errorDuringVerify;
      command.error = e;
      print('Error during verify phase of $command');
      notifyListeners();
      rethrow;
    }
  }

  void _complete(MultistageCommand command) {
    print('$command command succeeded');
    command._state = MultistageCommandState.success;
    notifyListeners();
  }
}

/// This is an "interface" in the sense that other classes should refer to all
/// instances of this with this static type. To prevent leaking implementation
/// details and making things too coupled and hard to change in the future.
abstract class MultistageCommand {
  var _state = MultistageCommandState.scheduled;

  // Clarification on terminology:
  //
  // [Exception] = the standard Dart term for a non-terminal failure condition
  //
  // "error"     = standard English term denoting something that went wrong
  //               during an operation
  //
  Exception? error;

  MultistageCommandState get state => _state;

  Future<void> request();

  Future<void> verify();

  @override
  String toString() => '$runtimeType{_state: $_state}';
}

enum MultistageCommandState {
  nonExistent,
  scheduled,
  requesting,
  verifying,
  success,
  errorDuringRequest,
  errorDuringVerify,
}

class TransactCommand extends MultistageCommand {
  TransactCommand(this.amount, this.fun);

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

class FakeCommand extends MultistageCommand {
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

class ErrantRequestCommand extends MultistageCommand {
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

class ErrantVerifyCommand extends MultistageCommand {
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
