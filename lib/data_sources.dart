import 'package:http/http.dart' as http;

import 'data_model.dart';

/// Watch out for https://flutter.dev/desktop#setting-up-entitlements

abstract class Trader {
  void buy(Holding holding);

  List<Holding> getMyHoldings();
}

class CoinbaseProTrader implements Trader {
  @override
  void buy(Holding holding) => throw UnimplementedError();

  @override
  List<Holding> getMyHoldings() => throw UnimplementedError();
}

abstract class Prices {
  Future<String> getCurrentPrice(Currency cryptocurrency);
}

class CoinbaseProPrices extends Prices {
  @override
  Future<String> getCurrentPrice(Currency cryptocurrency) async {
    final path = '/products/${cryptocurrency.callLetters}-USD/ticker';
    return CoinbaseApi.get(path);
  }
}

class CoinbaseApi {
  static final productionEndpoint = 'api.pro.coinbase.com';
  static final sandboxEndpoint = 'api-public.sandbox.pro.coinbase.com';
  static final useSandbox = false;
  static late final endpoint =
      useSandbox ? sandboxEndpoint : productionEndpoint;

  static Future<String> get(String path) async {
    final url = Uri.https(endpoint, path);
    final res = await http.get(url);
    return res.body;
  }
}
