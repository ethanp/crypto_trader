import 'package:crypto_trader/import_facade/controller.dart';

/// Whether to use live data or fake data.
class Environment {
  /// Use fake data iff true.
  static const bool fake = false;

  /// The [Brokerage] to use for the given environment.
  static Brokerage trader = fake ? FakeBrokerage() : CoinbaseProBrokerage();

  /// The [PriceSource] to use for the given environment.
  static PriceSource prices =
      fake ? FakePriceSource() : CoinbaseProPriceSource();
}
