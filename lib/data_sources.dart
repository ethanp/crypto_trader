import 'data_model.dart';

/// Watch out for https://flutter.dev/desktop#setting-up-entitlements

abstract class Trader {
  void buy(Holding holding);

  List<Holding> getMyHoldings();
}

class CoinbaseProTrader implements Trader {
  final url = 'https://api.pro.coinbase.com';

  @override
  void buy(Holding holding) => throw UnimplementedError();

  @override
  List<Holding> getMyHoldings() => throw UnimplementedError();
}

abstract class Prices {
  void getCurrentPrice(Cryptocurrency cryptocurrency);
}

class CoinbaseProPrices {
  void getCurrentPrice(Cryptocurrency cryptocurrency) =>
      throw UnimplementedError();
}
