import 'package:crypto_trader/import_facade/model.dart';

class Currency {
  const Currency({
    required this.name,
    required this.callLetters,
    required this.percentAllocation,
  });

  final String name;
  final String callLetters;
  final int percentAllocation;

  static Currency byLetters(String callLetters) =>
      Currencies.allCurrenciesMap[callLetters]!;

  // TODO use equatable mixin from pub get equatable.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency &&
          runtimeType == other.runtimeType &&
          callLetters == other.callLetters;

  @override
  int get hashCode => callLetters.hashCode;

  @override
  String toString() => 'Currency{name: $name, callLetters: $callLetters}';
}
