import 'dart:convert';
import 'dart:io';

import 'package:crypto_trader/import_facade/extensions.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:http/http.dart' as http;

import 'coinbase_account.dart';
import 'granularity.dart';
import 'private_headers.dart';

/// Handles actual interaction with the Coinbase Pro API for the app.
class CoinbaseApi {
  static const _oldEndpoint = 'api.pro.coinbase.com';
  static const _exchangeEndpoint = 'api.exchange.coinbase.com';

  Future<Dollars> currentPrice({required Currency of}) async {
    if (of == Currencies.dollars) return Dollars(1);
    final String from = of.callLetters;
    final String to = Currencies.dollars.callLetters;
    assert(from != to);
    final String path = 'products/$from-$to/ticker';
    final apiResponse = await _get(path: path);
    final priceStr = jsonDecode(apiResponse)['price'] as String;
    final double price = double.parse(priceStr);
    return Dollars(price);
  }

  /// https://docs.cloud.coinbase.com/exchange/reference/exchangerestapi_getproductcandles
  ///
  /// Coinbase allows retrieving up to 300 candles per request.
  /// So we're just limited by whatever looks best for the user.
  Future<String> candles(Currency currency, Granularity granularity,
      {required int count}) {
    return _get(
      path: 'products/${currency.callLetters}-USD/candles',
      params: {
        'granularity': granularity.duration.inSeconds.toString(),
        'start': DateTime.now()
            .subtract(granularity.duration * count)
            .toIso8601String(),
        'end': DateTime.now().toIso8601String(),
      },
      endpoint: _exchangeEndpoint,
    );
  }

  /// https://docs.pro.coinbase.com/#payment-method
  Future<String> deposit(Dollars dollars) async => _post(
        path: '/deposits/payment-method',
        body: {
          'amount': '${dollars.amt}',
          'currency': 'USD',
          'payment_method_id': await _getPaymentMethodId(),
        },
      );

  /// https://docs.pro.coinbase.com/?php#place-a-new-order
  Future<String> marketOrder(Holding order) => _post(
        path: '/orders',
        body: {
          'type': 'market',
          'side': 'buy',
          // Buy `currency` using USD.
          'product_id': '${order.currency.callLetters}-USD',
          // In "quote currency", which is USD in this case, eg. "$0.01".
          'funds': '${order.dollarValue.amt}',
        },
      );

  /// https://docs.pro.coinbase.com/#payment-methods
  Future<String> _getPaymentMethodId() async {
    final response = await _get(path: 'payment-methods', private: true);
    final decoded = jsonDecode(response) as List<dynamic>;
    return decoded.firstWhere(
        (e) => (e['name'] as String).contains('SCHWAB'))['id'] as String;
  }

  Future<String> _post({
    required String path,
    required Map<String, String> body,
  }) async {
    final url = Uri.https(_oldEndpoint, path);
    final headers = await PrivateHeaders.build(
      method: 'POST',
      path: path,
      body: jsonEncode(body),
    );
    print('posting meow');
    final postResponse = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    if (postResponse.statusCode != 200) {
      if (postResponse.body.toLowerCase().contains('insufficient funds')) {
        throw const InsufficientFundsException();
      } else {
        throw HttpException(
            '\n\nError in POST $url from Coinbase API!\n'
            'response code: ${postResponse.statusCode}\n'
            'response body: ${postResponse.body}\n'
            'sent headers: $headers\n'
            'sent body: $body\n\n',
            uri: url);
      }
    }
    return postResponse.body;
  }

  Future<String> _get({
    required String path,
    final bool private = false,
    final Map<String, String>? params,
    final String endpoint = _oldEndpoint,
  }) async {
    path = '/$path';
    print('Getting path:$path private:$private');
    final url = Uri.https(endpoint, path, params);
    final headers =
        private ? await PrivateHeaders.build(method: 'GET', path: path) : null;
    final res = await http.get(url, headers: headers);
    if (res.statusCode != 200) {
      throw StateError('\n\nError in GET $url from Coinbase API!\n'
          'response code: ${res.statusCode}\n'
          'response body: ${res.body}\n'
          'sent headers: $headers\n\n');
    }
    return res.body;
  }

  Future<Iterable<CoinbaseAccount>> getAccounts() async {
    final String holdingsResponse = await _get(path: 'accounts', private: true);
    final accountListRaw = jsonDecode(holdingsResponse) as List<dynamic>;
    return accountListRaw.map((raw) => CoinbaseAccount(raw));
  }

  Future<Dollars> totalDeposits() async {
    // TODO(cleanup): Cache this.
    print('retrieving deposits');
    final String transfersResponse =
        await _get(path: 'transfers', private: true);
    final transfers = jsonDecode(transfersResponse) as List<dynamic>;
    return Dollars(
        transfers.map((xfr) => double.parse(xfr['amount'] as String)).sum);
  }
}

class InsufficientFundsException implements Exception {
  const InsufficientFundsException([this.amountAttempted]);

  final Dollars? amountAttempted;

  @override
  String toString() {
    final suffix = amountAttempted != null ? ' to spend $amountAttempted' : '';
    return 'Insufficient funds$suffix';
  }
}
