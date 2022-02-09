import 'dart:async';

import 'package:crypto_trader/import_facade/ui.dart';
import 'package:flutter/material.dart';

/// Source: https://stackoverflow.com/a/68124708/1959155.
class TextWithCountdown extends StatefulWidget {
  /// A [Widget] that shows [text] and dismisses itself after [lifespan]
  /// seconds.
  const TextWithCountdown(this.text, {required this.lifespan});

  /// A [String] of [text] to be shown on this [Widget].
  final String text;

  /// Length of time to display this [Widget].
  final Duration lifespan;

  @override
  _TextWithCountdownState createState() => _TextWithCountdownState();
}

class _TextWithCountdownState extends State<TextWithCountdown> {
  late int count = widget.lifespan.inSeconds;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), _timerHandle);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MyText(
        '${widget.text}: ${count + 1}',
        style: TextStyle(color: Colors.grey[100], fontWeight: FontWeight.w500),
      );

  void _timerHandle(Timer timer) {
    setState(() => count -= 1);
    if (count <= 0) timer.cancel();
  }
}
