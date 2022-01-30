import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/util.dart';
import 'package:flutter/material.dart';

/// Simplified replacement API for the built-in `FutureBuilder`. Shows errors
/// in console, and on the screen in a Snackbar.
class EasyFutureBuilder<T> extends StatelessWidget {
  /// A [Widget] that may be different before and after a [future] completes.
  const EasyFutureBuilder({
    required this.future,
    this.builder,
    this.builderWithContext,
  }) : assert(
            (builder == null) != (builderWithContext == null),
            'Either builder or builderWithContext must be prosvided, '
            'but not both');

  /// Future that will contain data that widgets below depend on.
  final Future<T> future;

  /// A [Function] that can return different [Widget]s before and after the
  /// [future] completes (and may return data).
  final Widget Function(T?)? builder;

  /// A [Function] that *has access to the [BuildContext], and* can return
  /// different [Widget]s before and after the [future] completes (and may
  /// return data).
  final Widget Function(BuildContext, T?)? builderWithContext;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future.onError((error, stackTrace) {
        print(error);
        print(stackTrace);
        MySnackbar.create(context, '$error', const Duration(seconds: 3));
        return future;
      }),
      builder: (_ctx, holdings) => builder != null
          ? builder!(holdings.data)
          : builderWithContext!(_ctx, holdings.data),
    );
  }
}

/// Specify [Widget]s to be built before and after [Holdings] were retrieved.
class WithHoldings extends EasyFutureBuilder<Holdings> {
  /// A [Widget] that can look different before and after [Holdings] were retrieved.
  WithHoldings(
      {Widget Function(Holdings?)? builder,
      Widget Function(BuildContext, Holdings?)? builderWithContext})
      : super(
            future: Environment.trader.getMyHoldings(),
            builder: builder,
            builderWithContext: builderWithContext);
}

/// Specify [Widget]s to be built before and after [Earnings] were retrieved.
class WithEarnings extends EasyFutureBuilder<Dollars> {
  /// A [Widget] that can look different before and after [Earnings] were retrieved.
  WithEarnings({required Widget Function(Dollars?) builder})
      : super(future: Environment.trader.getMyEarnings(), builder: builder);
}
