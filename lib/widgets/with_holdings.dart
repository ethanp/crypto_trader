import 'package:crypto_trader/import_facade/controller.dart';
import 'package:crypto_trader/import_facade/model.dart';
import 'package:flutter/material.dart';

class WithHoldings extends StatelessWidget {
  const WithHoldings({required this.builder});

  final Widget Function(Holdings?) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Holdings>(
      future: Environment.trader.getMyHoldings(),
      builder: (_ctx, holdings) => builder(holdings.data),
    );
  }
}
