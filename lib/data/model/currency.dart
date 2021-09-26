import '../../import_facade/data_model.dart';

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency &&
          runtimeType == other.runtimeType &&
          callLetters == other.callLetters;

  @override
  int get hashCode => callLetters.hashCode;

  @override
  String toString() {
    return 'Currency{name: $name, callLetters: $callLetters}';
  }

  Holding holding({required Dollars dollarValue}) =>
      Holding(currency: this, dollarValue: dollarValue);
}
