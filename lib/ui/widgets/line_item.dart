import 'package:crypto_trader/import_facade/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LineItem extends StatelessWidget {
  const LineItem({
    required this.title,
    required this.value,
    this.percent,
    this.bigger = false,
    this.row = false,
  });

  final String title;
  final String? value;
  final double? percent;
  final bool bigger;
  final bool row;

  @override
  Widget build(BuildContext context) {
    final children = [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (value != null)
          MyText(value!, style: _Style.amountStyle(bigger: bigger))
        else
          const CupertinoActivityIndicator(),
        if (percent != null) _percentText()
      ]),
      Padding(
        padding: row
            ? const EdgeInsets.only(bottom: 2, right: 3)
            : const EdgeInsets.only(top: 6),
        child: MyText(row ? '$title: ' : title,
            style: _Style.labelStyle(bigger: bigger)),
      ),
    ];
    return Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 40, right: 20),
        child: row
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children.reversed.toList())
            : Column(children: children));
  }

  Widget _percentText() {
    final pct = percent!.toInt();
    var text = '$pct%';
    if (pct > 0) text = '+$text';
    return Padding(
        padding: const EdgeInsets.only(left: 7),
        child: MyText(text, style: _Style.percentStyle));
  }
}

class _Style {
  static TextStyle labelStyle({bool bigger = false}) =>
      GoogleFonts.aBeeZee().merge(TextStyle(
          color: Colors.grey[300],
          fontSize: bigger ? 24 : 14,
          fontWeight: FontWeight.w500));

  static TextStyle amountStyle({bool bigger = false}) =>
      TextStyle(color: Colors.green[300], fontSize: bigger ? 26 : 20);

  static final percentStyle =
      amountStyle().copyWith(fontSize: 16, color: Colors.lightBlueAccent);
}
