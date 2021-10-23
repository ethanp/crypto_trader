import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/util.dart';
import 'package:flutter/material.dart';

/// Simpler API than the built-in `FutureBuilder` for what I'm doing.
class EasyFutureBuilder<T> extends StatelessWidget {
  /// A [Widget] that may be different before and after a [future] completes.
  const EasyFutureBuilder({required this.future, this.builder, this.builderC})
      : assert((builder == null) != (builderC == null),
            'Either builder or builderC must be provided, but not both');

  /// Future that will contain data that widgets below depend on.
  final Future<T> future;

  /// A [Function] that can return different [Widget]s before and after the
  /// [future] completes (and may return data).
  final Widget Function(T?)? builder;

  final Widget Function(BuildContext, T?)? builderC;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future.onError((error, stackTrace) {
        print(error);
        print(stackTrace);
        MySnackbar(context, '$error', const Duration(seconds: 3));
        return future;
      }),
      builder: (_ctx, holdings) => builder != null
          ? builder!(holdings.data)
          : builderC!(_ctx, holdings.data),
    );
  }
}

/// Specify [Widget]s to be built before and after [Holdings] were retrieved.
class WithHoldings extends EasyFutureBuilder<Holdings> {
  /// A [Widget] that can look different before and after [Holdings] were retrieved.
  WithHoldings(
      {Widget Function(Holdings?)? builder,
      Widget Function(BuildContext, Holdings?)? builderC})
      : super(
            future: Environment.trader.getMyHoldings(),
            builder: builder,
            builderC: builderC);
}

/// Specify [Widget]s to be built before and after [Earnings] were retrieved.
class WithEarnings extends EasyFutureBuilder<Dollars> {
  /// A [Widget] that can look different before and after [Earnings] were retrieved.
  WithEarnings({required Widget Function(Dollars?) builder})
      : super(future: Environment.trader.getMyEarnings(), builder: builder);
}
