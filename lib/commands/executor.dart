import 'package:crypto_trader/import_facade/util.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

import 'command.dart';

/// Runs one [MultistageCommand] at a time, and will [notifyListeners()] when
/// the [MultistageCommandState] changes.
///
/// This class is testable using $BASE_DIR/lib/commands/main.dart.
class MultistageCommandExecutor extends ChangeNotifier {
  final _synchronizer = Lock(reentrant: true);

  MultistageCommand? currCommand;

  MultistageCommand get _command => currCommand!;

  MultistageCommandState get state =>
      currCommand?.state ?? MultistageCommandState.nonExistent;

  // This synchronization turns this Executor into an implicit Queue ADT.
  Future<void> add(MultistageCommand command) =>
      _synchronizer.synchronized(() async {
        print('starting $command');
        currCommand = command;
        await _request();
        await _verify();
        _complete();
      });

  Future<void> _request() async {
    // See https://dart.dev/codelabs/async-await#handling-errors
    try {
      _command.state = MultistageCommandState.requesting;
      notifyListeners();
      await _command.request();
    } on Exception catch (e) {
      _command.state = MultistageCommandState.errorDuringRequest;
      _command.error = e;
      print('Error during request phase of $currCommand: $e');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _verify() async {
    try {
      _command.state = MultistageCommandState.verifying;
      notifyListeners();
      await _command.verify();
    } on Exception catch (e) {
      _command.state = MultistageCommandState.errorDuringVerify;
      _command.error = e;
      print('Error during verify phase of $currCommand');
      notifyListeners();
      rethrow;
    }
  }

  void _complete() {
    print('$currCommand command succeeded');
    _command.state = MultistageCommandState.success;
    notifyListeners();
  }

  void resetError() {
    print('Resetting error');
    _command.state = MultistageCommandState.resetted;
    notifyListeners();
  }
}
