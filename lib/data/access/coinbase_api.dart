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
    final url = Uri.https(_endpoint, path);
    final headers =
        private ? await _privateHeaders(method: 'GET', path: path) : null;
    final res = await http.get(url, headers: headers);
    return res.body;
  }

  Future<Map<String, String>> _privateHeaders({
    required String method,
    required String path,
    String body = '',
  }) async {
    final config = await Config.loadFromDisk();
    final key = config.key;
    final passphrase = config.passphrase;

    // TODO(incomplete): Find out what the correct timestamp format is.
    final double timestamp = DateTime.now().millisecondsSinceEpoch / 1000;
    final Uint8List decodedKey = base64Decode(key);
    final Hmac hMac = Hmac(sha256, decodedKey);
    final String compendium = [
      timestamp.toString(),
      method.toUpperCase(),
      path,
      body,
    ].join();
    final Uint8List decodedCompendium = base64Decode(compendium);
    final Digest signature = hMac.convert(decodedCompendium);
    final List<int> bytes = signature.bytes;
    final String sigStr = base64Encode(bytes);
    final Map<String, String> headers = {
      'CB-ACCESS-KEY': key,
      'CB-ACCESS-SIGN': sigStr,
      'CB-ACCESS-TIMESTAMP': timestamp.toString(),
      'CB-ACCESS-PASSPHRASE': passphrase,
    };
    return headers;
  }
}
