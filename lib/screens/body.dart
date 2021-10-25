import 'package:crypto_trader/import_facade/ui_refresher.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

/// Outermost [Scaffold] for the app.
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UiRefresher.register(context);
    return Scaffold(
      appBar: _appBar(context),
      body: SafeArea(
        child: Column(children: [
          HoldingsFacts(),
          TransactionArea(),
          if (!_keyboardIsShowing(context)) Portfolio(),
        ]),
      ),
    );
  }

  AppBar _appBar(BuildContext context) => AppBar(
      elevation: 0,
      toolbarHeight: 65,
      backgroundColor: Colors.grey[900],
      title: const MyText('crypto_trader'),
      actions: [_refreshButton(context)]);

  Widget _refreshButton(BuildContext context) => InkWell(
      onTap: () => UiRefresher.refresh(context),
      child: Padding(
          padding: const EdgeInsets.all(12),
          child: Stack(children: [_icon(context), _label()])));

  Widget _label() => const Positioned(
      bottom: 3,
      child: Text('reload', style: TextStyle(fontSize: 8, color: Colors.grey)));

  Widget _icon(BuildContext context) =>
      Icon(Icons.refresh, size: 25, color: Colors.grey[300]!.withGreen(250));

  bool _keyboardIsShowing(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom != 0;
}
