import 'package:crypto_trader/import_facade/model.dart';

/// Could be a cryptocurrency, or [Dollars].
class Currency {
  /// Could be a cryptocurrency, or [Dollars].
  const Currency({
    required this.name,
    required this.callLetters,
    required this.percentAllocation,
  });

  /// The full name of the currency, eg. "Bitcoin Cash".
  final String name;

  /// Call letters for the currency, eg. "BTC".
  final String callLetters;

  /// Percentage of portfolio allocated to this currency.
  final int percentAllocation;

  /// Retrieve a [Currency] using its [callLetters].
  static Currency byCallLetters(String callLetters) =>
      Currencies.allCurrenciesMap[callLetters]!;

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
