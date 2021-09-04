import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
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

  final useSandbox;

  late final endpoint = useSandbox ? sandboxEndpoint : productionEndpoint;

  Future<String> get({
    required String path,
    bool private = false,
  }) async {
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
    // TODO load these in from the file system or something (encrypted).
    //  Recall that losing access to these will not lose me any money.
    final key = '';
    final passphrase = '';

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
}
