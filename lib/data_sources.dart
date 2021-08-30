import 'data_model.dart';

/// Watch out for https://flutter.dev/desktop#setting-up-entitlements

abstract class Trader {
  void buy(Holding holding);

  List<Holding> getMyHoldings();
}

class CoinbaseProTrader implements Trader {
  final apiEndpoint = 'https://api.pro.coinbase.com';

  @override
  void buy(Holding holding) => throw UnimplementedError();

  @override
  List<Holding> getMyHoldings() => throw UnimplementedError();
}

abstract class Prices {
  void getCurrentPrice(Currency cryptocurrency);
}

class CoinbaseProPrices {
  final apiEndpoint = 'https://api.pro.coinbase.com';
  final sandboxEndpoint = 'https://api-public.sandbox.pro.coinbase.com';

  void getCurrentPrice(Currency cryptocurrency) {
    // ignore: unused_local_variable
    final url = '$sandboxEndpoint/products/BTC-USD/ticker';
  }
}
