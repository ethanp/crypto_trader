import 'package:flutter/material.dart';

// TODO(bug): Hiding the keyboard undoes the most recent update to the field.
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
