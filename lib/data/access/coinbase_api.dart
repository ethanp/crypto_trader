import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:crypto_trader/data/access/config.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:http/http.dart' as http;

class CoinbaseApi {
  static final coinbaseProAddress = 'pro.coinbase.com';
  static final productionEndpoint = 'api.$coinbaseProAddress';
  static final sandboxEndpoint = 'api-public.sandbox.$coinbaseProAddress';

  CoinbaseApi({this.useSandbox = false});

  final bool useSandbox;

  late final String _endpoint =
      useSandbox ? sandboxEndpoint : productionEndpoint;

  /// https://docs.pro.coinbase.com/#payment-method
  Future<String> deposit(Dollars dollars) async => await _post(
        path: '/deposits/payment-method',
        body: {
          'amount': '${dollars.amt}',
          'currency': 'USD',
          'payment_method_id': await _getPaymentMethodId(),
        },
      );

  /// https://docs.pro.coinbase.com/?php#place-a-new-order
  Future<String> marketOrder(Holding order) async => await _post(
        path: '/orders',
        body: {
          "type": "market",
          "side": "buy",
          // Buy `currency` using USD.
          "product_id": "${order.currency.callLetters}-USD",
          // In "quote currency", which is USD in this case, eg. "$0.01".
          "funds": "${order.dollarValue.amt}",
        },
      );

  /// https://docs.pro.coinbase.com/#payment-methods
  Future<String> _getPaymentMethodId() async {
    final response = await get(path: '/payment-methods', private: true);
    final List<dynamic> decoded = jsonDecode(response);
    return decoded.firstWhere((e) => e['name'].contains("SCHWAB"))['id'];
  }

  Future<String> _post({
    required String path,
    required Map<String, String> body,
  }) async {
    final url = Uri.https(_endpoint, path);
    final headers = await _privateHeaders(
      method: 'POST',
      path: path,
      body: jsonEncode(body),
    );
    print('posting meow');
    final res = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    // TODO show this to the user too
    if (res.statusCode != 200) {
      throw StateError('\n\nError in POST $url from Coinbase API!\n'
          'response code: ${res.statusCode}\n'
          'response body: ${res.body}\n'
          'sent headers: $headers\n'
          'sent body: $body\n\n');
    }
    return res.body;
  }

  Future<String> get({
    required String path,
    bool private = false,
  }) async {
    print('Getting $path private:$private');
    final url = Uri.https(_endpoint, path);
    final headers =
        private ? await _privateHeaders(method: 'GET', path: path) : null;
    final res = await http.get(url, headers: headers);
    // TODO show this to the user too
    if (res.statusCode != 200) {
      throw StateError('\n\nError in GET $url from Coinbase API!\n'
          'response code: ${res.statusCode}\n'
          'response body: ${res.body}\n'
          'sent headers: $headers\n\n');
    }
    return res.body;
  }

  /// https://docs.pro.coinbase.com/#creating-a-request
  /// NB: Perusing the linked library impls is required to get it working.
  Future<Map<String, String>> _privateHeaders({
    required String method,
    required String path,
    String body = '',
  }) async {
    final Config config = await Config.loadFromDisk();
    final int timestamp = _timestamp();

    return <String, String>{
      "accept": "application/json",
      "content-type": "application/json",
      "User-Agent": "Unofficial Flutter coinbase pro api library",
      'CB-ACCESS-KEY': config.key,
      'CB-ACCESS-SIGN': _signature(timestamp, method, path, body, config),
      'CB-ACCESS-TIMESTAMP': timestamp.toString(),
      'CB-ACCESS-PASSPHRASE': config.passphrase,
    };
  }

  String _signature(
    int timestamp,
    String method,
    String path,
    String body,
    Config config,
  ) {
    final List<String> prehash = [
      timestamp.toString(),
      method.toUpperCase(),
      path,
      body,
    ];
    final Uint8List secret = base64.decode(config.secret);
    final Hmac hmac = Hmac(sha256, secret);
    final Digest digest = hmac.convert(utf8.encode(prehash.join()));
    final String signature = base64.encode(digest.bytes);
    return signature;
  }

  int _timestamp() {
    final double secondsSinceEpoch =
        DateTime.now().millisecondsSinceEpoch / 1000;
    return secondsSinceEpoch.round();
  }
}
