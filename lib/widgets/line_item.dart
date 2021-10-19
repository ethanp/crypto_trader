import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LineItem extends StatelessWidget {
  const LineItem({
    required this.title,
    required this.value,
    this.percent,
  });

  final String title;
  final String? value;
  final double? percent;

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyText('$title: ', style: _Style.labelStyle),
          if (value != null)
            MyText(value!, style: _Style.amountStyle)
          else
            const CupertinoActivityIndicator(),
          if (percent != null)
            Padding(
                padding: const EdgeInsets.only(left: 14),
                child: MyText(
                  '+${percent!.toInt()}%',
                  style: _Style.percentStyle,
                ))
        ],
      ));
}

class _Style {
  static final labelStyle = GoogleFonts.aBeeZee().merge(
    TextStyle(
      color: Colors.grey[300],
      fontSize: 15,
      fontWeight: FontWeight.w900,
    ),
  );
  static final amountStyle = TextStyle(
    color: Colors.green[300],
    fontSize: 17,
  );
  static final percentStyle = amountStyle.copyWith(fontSize: 13);
}
