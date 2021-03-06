import 'dart:math';

import 'package:intl/intl.dart';

class Dollars {
  Dollars(this.amt);

  factory Dollars.random({required int max}) =>
      Dollars((Random().nextDouble() * max * 100).round() / 100.0);

  double amt;

  @override
  String toString() => NumberFormat.simpleCurrency().format(amt);

  Dollars operator +(Dollars o) => Dollars(amt + o.amt);

  Dollars operator -(Dollars o) => Dollars(amt - o.amt);

  Dollars operator *(double o) => Dollars(amt * o);

  Dollars operator /(Dollars o) => Dollars(amt / o.amt);

  double get rounded => double.parse(amt.toStringAsFixed(2));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dollars && runtimeType == other.runtimeType && amt == other.amt;

  @override
  int get hashCode => amt.hashCode;
}
