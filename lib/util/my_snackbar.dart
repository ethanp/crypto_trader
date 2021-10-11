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
          backgroundColor: Colors.grey[900],
          content: TextWithCountdown(text, lifespan: duration),
          duration: duration,
          action: SnackBarAction(
              label: 'Dismiss',
              onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
              textColor: Colors.blueGrey[100])));
}
