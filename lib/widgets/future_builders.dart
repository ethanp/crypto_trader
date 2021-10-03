import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/util.dart';
import 'package:flutter/material.dart';

class EasyFutureBuilder<T> extends StatelessWidget {
  const EasyFutureBuilder({required this.future, required this.builder});

  final Future<T> future;
  final Widget Function(T?) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future.onError((error, stackTrace) {
        print(error);
        print(stackTrace);
        EasySnackbar.simple(
          context: context,
          text: '$error',
          duration: Duration(seconds: 3),
        );
        return future;
      }),
      builder: (_ctx, holdings) => builder(holdings.data),
    );
  }
}

class WithHoldings extends EasyFutureBuilder<Holdings> {
  WithHoldings({required Widget Function(Holdings?) builder})
      : super(future: Environment.trader.getMyHoldings(), builder: builder);
}

class WithEarnings extends EasyFutureBuilder<Dollars> {
  WithEarnings({required Widget Function(Dollars?) builder})
      : super(future: Environment.trader.getMyEarnings(), builder: builder);
}
