import 'package:crypto_trader/import_facade/data_controller.dart';

class Environment {
  static const bool fake = false;
  static Trader trader = fake ? FakeTrader() : CoinbaseProTrader();
  static Prices prices = fake ? FakePrices() : CoinbaseProPrices();
}
