import 'package:crypto_trader/import_facade/controller.dart';

class Environment {
  static const bool fake = false;
  static Brokerage trader = fake ? FakeBrokerage() : CoinbaseProBrokerage();
  static Prices prices = fake ? FakePrices() : CoinbaseProPrices();
}
