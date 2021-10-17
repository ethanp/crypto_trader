import 'dart:convert';

import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/extensions.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:http/http.dart' as http;

import 'granularity.dart';
import 'private_headers.dart';

/// Handles actual interaction with the Coinbase Pro API for the app.
class CoinbaseApi {
  static const _oldEndpoint = 'api.pro.coinbase.com';
  static const _exchangeEndpoint = 'api.exchange.coinbase.com';

  /// https://docs.cloud.coinbase.com/exchange/reference/exchangerestapi_getproductcandles
  Future<String> candles(Currency currency,
      [Granularity granularity = Granularity.sixHours]) {
    return get(
      path: 'products/${currency.callLetters}-USD/candles',
      params: {
        'granularity': granularity.duration.toString(),
        'start': DateTime.now()
            .subtract(granularity.duration * 16)
            .toIso8601String(),
        'end': DateTime.now().toIso8601String(),
      },
      endpoint: _exchangeEndpoint,
    );
  }

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
    final response = await get(path: 'payment-methods', private: true);
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
        throw StateError('Insufficient Funds');
      } else {
        throw StateError('\n\nError in POST $url from Coinbase API!\n'
            'response code: ${postResponse.statusCode}\n'
            'response body: ${postResponse.body}\n'
            'sent headers: $headers\n'
            'sent body: $body\n\n');
      }
    }
    return postResponse.body;
  }

  Future<String> get({
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

  Future<Iterable<_CoinbaseAccount>> getAccounts() async {
    final String holdingsResponse = await get(path: 'accounts', private: true);
    final accountListRaw = jsonDecode(holdingsResponse) as List<dynamic>;
    return accountListRaw.map((raw) => _CoinbaseAccount(raw));
  }

  Future<Dollars> totalDeposits() async {
    // TODO(cleanup): Cache this.
    print('retrieving deposits');
    final String transfersResponse =
        await get(path: 'transfers', private: true);
    final transfers = jsonDecode(transfersResponse) as List<dynamic>;
    return Dollars(
        transfers.map((xfr) => double.parse(xfr['amount'] as String)).sum);
  }
}

/// Converter between the external Coinbase API data model,
/// and the internal [Holdings] data model.
class _CoinbaseAccount {
  const _CoinbaseAccount(this.acct);

  /// Raw coinbase data about a single [Holding].
  final dynamic acct;

  /// True iff this account holds a currency that is part of our portfolio.
  bool get isSupported => Currencies.allCurrenciesMap.containsKey(_callLetters);

  /// Materialize a [Holding] out of this [_CoinbaseAccount].
  Future<Holding> get asHolding async {
    final Currency currency = Currency.byCallLetters(_callLetters);
    final Dollars priceInDollars =
        await Environment.prices.currentPrice(of: currency);
    return Holding(
      currency: currency,
      dollarValue: priceInDollars * _balanceInCurrency,
    );
  }

  String get _callLetters => acct['currency'] as String;

  double get _balanceInCurrency => double.parse(acct['balance'] as String);
}
