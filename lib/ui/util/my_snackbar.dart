import 'package:crypto_trader/import_facade/ui.dart';
import 'package:flutter/material.dart';

class MySnackbar {
  /// Create an standardized-for-this-app snackbar.
  ///
  /// Layout diagram:
  ///
  ///    | `text`: [seconds remaining]   [Dismiss button] |
  ///
  /// 1) The [seconds remaining] ticks down each second
  /// 2) When [seconds remaining] hits zero, the snackbar is auto-dismissed
  ///
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> create(
    BuildContext context,
    String text,
    Duration duration,
  ) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.grey[900],
          content: TextWithCountdown(text, lifespan: duration),
          duration: duration,
          action: SnackBarAction(
              label: 'Dismiss',
              onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
              textColor: Colors.blueGrey[100])));
}
