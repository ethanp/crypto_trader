import 'dart:math';

import 'package:crypto_trader/data/controller/data_controller.dart';
import 'package:intl/intl.dart';

import 'data_model.dart';

class Dollars {
  Dollars(this.amt);

  double amt;

  factory Dollars.random({required int max}) =>
      Dollars((Random().nextDouble() * max * 100).round() / 100.0);

  @override
  String toString() => NumberFormat.simpleCurrency().format(amt);

  Dollars operator +(double o) => Dollars(amt + o);

  Dollars operator *(double o) => Dollars(amt * o);

  Dollars operator /(Dollars o) => Dollars(amt / o.amt);

  // TODO: I never thought through whether this one is correct.
  Future<double> translateTo(Currency currency) async =>
      (await Environment.prices.currentPrice(of: currency) / this).amt;

  double get rounded => double.parse(this.amt.toStringAsFixed(2));
}
