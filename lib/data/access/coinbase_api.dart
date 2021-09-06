import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:crypto_trader/data/access/config.dart';
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
  Future<String> limitOrder() async {
    final Map<String, String> body = {
      // Amount in "base currency", which I think is USD in my case
      "size": "0.01",
      // Price per crypto-coin
      "price": "0.100",
      "side": "buy",
      // Buy BTC using USD
      "product_id": "BTC-USD"
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
      print('Error in get from Coinbase API!');
      print('status code: ${res.statusCode}, body: ${res.body}');
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
      "User-Agent": "gdax-flutter unofficial coinbase pro api library",
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
