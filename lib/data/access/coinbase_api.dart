import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:crypto_trader/data/access/config.dart';
import 'package:http/http.dart' as http;

class CoinbaseApi {
  static final coinbaseProAddress = 'pro.coinbase.com';
  static final productionEndpoint = 'api.$coinbaseProAddress';
  static final sandboxEndpoint = 'api-public.sandbox.$coinbaseProAddress';

  CoinbaseApi({this.useSandbox = false});

  final bool useSandbox;

  late final String _endpoint =
      useSandbox ? sandboxEndpoint : productionEndpoint;

  Future<String> get({
    required String path,
    bool private = false,
  }) async {
    print('get $path, private: $private');
    final url = Uri.https(_endpoint, path);
    print('url $url');
    final headers =
        private ? await _privateHeaders(method: 'GET', path: path) : null;
    print('headers: $headers');
    print('Get: $url\nHeaders: $headers');
    final res = await http.get(url, headers: headers);
    if (res.statusCode != 200) {
      print('Error in get from Coinbase API!');
      print('status code: ${res.statusCode}, body: ${res.body}');
    }
    return res.body;
  }

  Future<Map<String, String>> _privateHeaders({
    required String method,
    required String path,
    String body = '',
  }) async {
    final Config config = await Config.loadFromDisk();
    final int timestamp = _timestamp();
    final List<String> prehash = [
      timestamp.toString(),
      method.toUpperCase(),
      path,
      body,
    ];
    final Uint8List secret = base64.decode(config.secret);
    final Hmac hmac2 = Hmac(sha256, secret);
    final Digest digest = hmac2.convert(utf8.encode(prehash.join()));
    final String signature = base64.encode(digest.bytes);

    /// https://docs.pro.coinbase.com/#creating-a-request
    final Map<String, String> headers = {
      "accept": "application/json",
      "content-type": "application/json",
      "User-Agent": "gdax-flutter unofficial coinbase pro api library",
      'CB-ACCESS-KEY': config.key,
      'CB-ACCESS-SIGN': signature,
      'CB-ACCESS-TIMESTAMP': timestamp.toString(),
      'CB-ACCESS-PASSPHRASE': config.passphrase,
    };
    return headers;
  }

  int _timestamp() {
    final double secondsSinceEpoch =
        DateTime.now().millisecondsSinceEpoch / 1000;
    return secondsSinceEpoch.round();
  }
}
