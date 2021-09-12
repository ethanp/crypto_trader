import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:crypto_trader/data/access/config.dart';
import 'package:crypto_trader/data/data_sources.dart';
import 'package:crypto_trader/data_model.dart';
import 'package:http/http.dart' as http;

class CoinbaseApi {
  static final coinbaseProAddress = 'pro.coinbase.com';
  static final productionEndpoint = 'api.$coinbaseProAddress';
  static final sandboxEndpoint = 'api-public.sandbox.$coinbaseProAddress';

  CoinbaseApi({this.useSandbox = true});

  final bool useSandbox;

  late final String _endpoint =
      useSandbox ? sandboxEndpoint : productionEndpoint;

  /// https://docs.pro.coinbase.com/?php#place-a-new-order
  Future<String> limitOrder(Holding order) async {
    final Dollars price =
        // Beware: Using a FakePrices() instance here would be dangerous!
        await CoinbaseProPrices().currentPrice(of: order.currency);
    final amount = order.dollarValue.translateTo(order.currency);
    final Map<String, String> body = {
      // Amount in "base currency", which is BTC in this case, eg. "0.01".
      "size": "$amount",
      // Price per crypto-coin (limit order), eg. "0.100".
      "price": "${price.amt}",
      "side": "buy",
      // Buy `currency` using USD
      "product_id": "${order.currency.callLetters}-USD"
    };
    final String path = '/orders';
    final url = Uri.https(_endpoint, path);
    final headers = await _privateHeaders(method: 'GET', path: path);
    final res = await http.post(url, headers: headers, body: body);
    return res.body;
  }

  Future<String> get({
    required String path,
    bool private = false,
  }) async {
    final url = Uri.https(_endpoint, path);
    final headers =
        private ? await _privateHeaders(method: 'GET', path: path) : null;
    final res = await http.get(url, headers: headers);
    if (res.statusCode != 200) {
      throw StateError('\n\nError in GET $url from Coinbase API!\n'
          'status code: ${res.statusCode}\n'
          'body: ${res.body}\n'
          'headers: $headers\n\n');
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
