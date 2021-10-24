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
      command.state = MultistageCommandState.requesting;
      notifyListeners();
      await command.request();
    } on Exception catch (e) {
      command.state = MultistageCommandState.errorDuringRequest;
      command.error = e;
      print('Error during request phase of $command');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _verify(MultistageCommand command) async {
    try {
      command.state = MultistageCommandState.verifying;
      notifyListeners();
      await command.verify();
    } on Exception catch (e) {
      command.state = MultistageCommandState.errorDuringVerify;
      command.error = e;
      print('Error during verify phase of $command');
      notifyListeners();
      rethrow;
    }
  }

  void _complete(MultistageCommand command) {
    print('$command command succeeded');
    command.state = MultistageCommandState.success;
    notifyListeners();
  }
}
