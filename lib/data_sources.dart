import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

abstract class Prices extends ChangeNotifier {
  Future<String> getCurrentPrice({
    required Currency of,
    Currency units = dollars,
  });

  static Prices coinbasePro() {
    return CoinbaseProPrices();
  }
}

class CoinbaseProPrices extends Prices {
  @override
  Future<String> getCurrentPrice({
    required Currency of,
    Currency units = dollars,
  }) async {
    final String from = of.callLetters;
    final String to = units.callLetters;
    final String path = '/products/$from-$to/ticker';
    final String apiResponse = await CoinbaseApi().get(path: path);
    final String priceStr = jsonDecode(apiResponse)['price'];
    final double price = double.parse(priceStr);
    final String formatted = NumberFormat.simpleCurrency().format(price);
    return formatted;
  }
}

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
    final config = await _loadConfigFromDisk();
    final key = config.key;
    final passphrase = config.passphrase;

    // TODO(incomplete): pretty sure this timestamp formatting is not correct.
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

  Future<Config> _loadConfigFromDisk() async {
    final a = await rootBundle.loadString('config/config.json');
    return Config(jsonDecode(a));
  }
}

class Config {
  const Config(this.loaded);
  final dynamic loaded;

  String get key => loaded['key'];
  String get passphrase => loaded['passphrase'];

  /// Can be useful for debugging.
  @override
  String toString() {
    final fields = <String, String>{
      'key': key,
      'passphrase': passphrase,
    }.entries.map((e) => '${e.key}: ${e.value}').join(',\n  ');
    return 'Config{\n  $fields\n}';
  }
}
