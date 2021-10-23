import 'package:crypto_trader/import_facade/util.dart';

/// This is an "interface" in the sense that other classes should refer to all
/// instances of this with this static type. To prevent leaking implementation
/// details and making things too coupled and hard to change in the future.
abstract class MultistageCommand {
  MultistageCommandState state = MultistageCommandState.scheduled;

  // Clarification on terminology:
  //
  // [Exception] = the standard Dart term for a non-terminal failure condition
  //
  // "error"     = standard English term denoting something that went wrong
  //               during an operation
  //
  Exception? error;

  Future<void> request();

  Future<void> verify();

  @override
  String toString() => '$runtimeType{_state: $state}';
}
