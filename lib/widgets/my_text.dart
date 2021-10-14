import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Text widget pre-themed for use in this app.
class MyText extends StatelessWidget {
  /// Text widget pre-themed for use in this app.
  const MyText(this.text, {this.style, this.fontSize});

  /// The string to display in the widget.
  final String text;

  /// Style to apply atop the default MyText style.
  final TextStyle? style;

  /// Size of shown text (overrides what is set in [style]).
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.libreBaskerville()
            .merge(style)
            .copyWith(fontSize: fontSize));
  }
}
