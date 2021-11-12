import 'package:crypto_trader/import_facade/util.dart';

/// This is an "interface": Prefer referring to subclass instances of these
/// as type [MultistageCommand], to prevent leaking implementation details
/// and making things too coupled and hard to change in the future.
abstract class MultistageCommand {
  MultistageCommandState state = MultistageCommandState.scheduled;

  /// [Exception] caught while executing the command. Check the [state] to see
  /// whether the error happened during [request] or [verify].
  ///
  /// Clarification on terminology:
  ///
  /// [Exception] = the standard Dart term for a non-terminal failure condition
  ///
  /// "error"     = standard English term denoting something that went wrong
  ///               during an operation
  ///
  Exception? error;

  Future<void> request();

  Future<void> verify();

  @override
  String toString() => '$runtimeType(state: $state)';

  String get title;
}
