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
    return CoinbaseApi().get(path);
  }
}

class CoinbaseApi {
  static final coinbaseProAddress = 'pro.coinbase.com';
  static final productionEndpoint = 'api.$coinbaseProAddress';
  static final sandboxEndpoint = 'api-public.sandbox.$coinbaseProAddress';

  CoinbaseApi({this.useSandbox = false});

  final useSandbox;

  late final endpoint = useSandbox ? sandboxEndpoint : productionEndpoint;

  Future<String> get(String path, {Map<String, String>? headers}) async {
    final url = Uri.https(endpoint, path);
    final res = await http.get(url, headers: headers);
    return res.body;
  }

  Future<String> getPrivate(String path) async {
    // TODO(feature-infra): Create the headers.
    final key = '';
    final signature = '';
    final timestamp = '';
    final passphrase = '';
    return get(path, headers: {
      'CB-ACCESS-KEY': key,
      'CB-ACCESS-SIGN': signature,
      'CB-ACCESS-TIMESTAMP': timestamp,
      'CB-ACCESS-PASSPHRASE': passphrase,
    });
  }
}
