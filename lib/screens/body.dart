import 'package:crypto_trader/import_facade/ui_refresher.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

/// Outermost [Scaffold] for the app.
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UiRefresher.register(context);
    final tabs = _tabs(context);
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
          appBar: _appBar(context, tabs),
          body: TabBarView(children: tabs.map((t) => t.body).toList())),
    );
  }

  List<TabGo> _tabs(BuildContext context) => [
        TabGo(
          title: 'OG UI',
          icon: const Icon(Icons.save),
          body: Column(children: [
            HoldingsFacts(),
            TransactionArea(),
            if (!_keyboardIsShowing(context)) Portfolio(),
          ]),
        ),
        TabGo(
          title: 'NewNew UI',
          icon: const Icon(Icons.cloud_circle),
          body: Column(children: [
            HoldingsFacts(),
            if (!_keyboardIsShowing(context)) Portfolio(),
          ]),
        ),
      ];

  AppBar _appBar(BuildContext context, List<TabGo> tabs) => AppBar(
      elevation: 0,
      toolbarHeight: 65,
      backgroundColor: Colors.grey[900]!.withBlue(50),
      title: TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          indicator: const UnderlineTabIndicator(
            insets: EdgeInsets.only(bottom: 12.0),
          ),
          tabs: [...tabs.map((t) => t.tab)]),
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

class TabGo {
  const TabGo({required this.title, required this.icon, required this.body});

  final String title;
  final Icon icon;
  final Widget body;

  Tab get tab => Tab(text: title, icon: icon);
}
