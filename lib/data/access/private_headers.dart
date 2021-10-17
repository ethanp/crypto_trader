import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'coinbase_api_config.dart';

class PrivateHeaders {
  /// https://docs.pro.coinbase.com/#creating-a-request
  /// NB: Perusing the linked library impls is required to get it working.
  static Future<Map<String, String>> build({
    required String method,
    required String path,
    String body = '',
  }) async {
    final Config config = await Config.loadFromDisk();
    final int timestamp = _currentTime();

    return <String, String>{
      'accept': 'application/json',
      'content-type': 'application/json',
      'User-Agent': 'Unofficial Flutter coinbase pro api library',
      'CB-ACCESS-KEY': config.key,
      'CB-ACCESS-SIGN': _signature(timestamp, method, path, body, config),
      'CB-ACCESS-TIMESTAMP': timestamp.toString(),
      'CB-ACCESS-PASSPHRASE': config.passphrase,
    };
  }

  /// Special magic that I'm quite proud of penning that implements
  /// Coinbase Pro API's special signature algorithm. There's no official
  /// library for the API in Dart, so I had to write it out.
  static String _signature(
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

  /// Seconds since "epoch".
  ///
  /// Eg. `1634079032` would be Oct 12 '21 6:50pm
  static int _currentTime() =>
      (DateTime.now().millisecondsSinceEpoch / 1000).round();
}
