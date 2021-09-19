import 'package:flutter/material.dart';

class EnableKeyboardHiding extends StatelessWidget {
  const EnableKeyboardHiding({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /// Hide the keyboard on global tap.
      ///
      /// Sources:
      ///   • https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
      ///   • https://stackoverflow.com/a/62327156/1959155
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}
