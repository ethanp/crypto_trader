import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

/// Pre-configured snackbar for easy use across the app.
class MySnackbar {
  static void simple({
    required BuildContext context,
    required String text,
    required Duration duration,
  }) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWithCountdown(text, initialCount: duration.inSeconds),
        duration: duration,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
          textColor: Colors.blueGrey[200],
        ),
      ));
}
