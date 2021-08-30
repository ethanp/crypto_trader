import 'package:http/http.dart' as http;

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
  Future<String> getCurrentPrice(Currency cryptocurrency);
}

class CoinbaseProPrices extends Prices {
  final apiEndpoint = 'api.pro.coinbase.com';
  final sandboxEndpoint = 'api-public.sandbox.pro.coinbase.com';

  @override
  Future<String> getCurrentPrice(Currency cryptocurrency) async {
    // ignore: unused_local_variable
    final path = '/products/BTC-USD/ticker';
    final url = Uri.https(sandboxEndpoint, path);
    final res = await http.get(url);
    return res.body;
  }
}
