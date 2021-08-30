import 'dart:convert';

import 'package:crypto/crypto.dart';
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

  Future<String> get(String path, {bool private = false}) async {
    final url = Uri.https(endpoint, path);
    final headers = private ? _privateHeaders(method: 'GET', path: path) : null;
    final res = await http.get(url, headers: headers);
    return res.body;
  }

  Map<String, String> _privateHeaders({
    required String method,
    required String path,
    String body = '',
  }) {
    final key = '';
    final passphrase = '';

    // TODO pretty sure this timestamp formatting is not correct.
    final timestamp = DateTime.now().millisecondsSinceEpoch / 1000;
    final what = timestamp.toString() + method.toUpperCase() + path + body;
    final hMac = Hmac(sha256, base64Decode(key));
    final signature = hMac.convert(base64Decode(what));
    final sigStr = base64Encode(signature.bytes);
    final headers = {
      'CB-ACCESS-KEY': key,
      'CB-ACCESS-SIGN': sigStr,
      'CB-ACCESS-TIMESTAMP': timestamp.toString(),
      'CB-ACCESS-PASSPHRASE': passphrase,
    };
    return headers;
  }
}
