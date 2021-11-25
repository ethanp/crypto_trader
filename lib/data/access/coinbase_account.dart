import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';

/// Converter between the external Coinbase API data model,
/// and the internal [Holdings] data model.
class CoinbaseAccount {
  const CoinbaseAccount(this.acct);

  /// Raw coinbase data about a single [Holding].
  final dynamic acct;

  /// True iff this account holds a currency that is part of our portfolio.
  bool get isSupported =>
      Currencies.asMapByCallLetters.containsKey(_callLetters);

  /// Materialize a [Holding] out of this [CoinbaseAccount].
  Future<Holding> get asHolding async {
    final Currency currency = Currency.byCallLetters(_callLetters);
    final Dollars priceInDollars =
        await Environment.prices.currentPrice(of: currency);
    return Holding(
      currency: currency,
      dollarValue: priceInDollars * _balanceInCurrency,
    );
  }

  String get _callLetters => acct['currency'] as String;

  double get _balanceInCurrency => double.parse(acct['balance'] as String);
}
