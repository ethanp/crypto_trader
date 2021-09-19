import 'dart:async';

import 'package:flutter/material.dart';

/// Source: https://stackoverflow.com/a/68124708/1959155.
class TextWithCountdown extends StatefulWidget {
  final String text;
  final int initialCount;

  const TextWithCountdown(this.text, {required this.initialCount});

  @override
  _TextWithCountdownState createState() => _TextWithCountdownState();
}

class _TextWithCountdownState extends State<TextWithCountdown> {
  late int count = widget.initialCount;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), _timerHandle);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Container(child: Text('${widget.text}: ${count + 1}'));

  void _timerHandle(Timer timer) {
    setState(() => count -= 1);
    if (count <= 0) timer.cancel();
  }
}
