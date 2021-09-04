import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../data_model.dart';
import 'config.dart';

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

  static Prices fake() => FakePrices();

  static Prices coinbasePro() => CoinbaseProPrices();
}

class FakePrices extends Prices {
  @override
  Future<String> getCurrentPrice({
    required Currency of,
    Currency units = dollars,
  }) =>
      Future.value('0');
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
