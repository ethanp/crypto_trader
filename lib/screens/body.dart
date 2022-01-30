import 'package:crypto_trader/import_facade/ui_refresher.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

/// Outermost [Scaffold] for the app.
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UiRefresher.register(context);
    final keyboardIsHidden = MediaQuery.of(context).viewInsets.bottom == 0;
    final tabs = [
      TabGo(
        title: 'OG UI',
        icon: const Icon(Icons.save),
        body: Column(children: [
          HoldingsFacts(),
          TransactionArea(),
          if (keyboardIsHidden) Portfolio(),
        ]),
      ),
      TabGo(
        title: 'NewNew UI',
        icon: const Icon(Icons.cloud_circle),
        body: Column(children: [
          HoldingsFacts(),
          if (keyboardIsHidden) Portfolio(),
        ]),
      ),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            toolbarHeight: 65,
            backgroundColor: Colors.grey[900]!.withBlue(50),
            title: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                indicator: const UnderlineTabIndicator(
                  insets: EdgeInsets.only(bottom: 12.0),
                ),
                tabs: [...tabs.map((t) => t.tab)]),
            actions: [_refreshButton(context)]),
        body: TabBarView(
          children: [...tabs.map((t) => t.body)],
        ),
      ),
    );
  }

  Widget _refreshButton(BuildContext context) {
    final icon =
        Icon(Icons.refresh, size: 25, color: Colors.grey[300]!.withGreen(250));
    const label = Positioned(
      bottom: 3,
      child: Text(
        'reload',
        style: TextStyle(
          fontSize: 8,
          color: Colors.grey,
        ),
      ),
    );
    return InkWell(
      onTap: () => UiRefresher.refresh(context),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [icon, label],
        ),
      ),
    );
  }
}

class TabGo {
  const TabGo({required this.title, required this.icon, required this.body});

  final String title;
  final Icon icon;
  final Widget body;

  Tab get tab => Tab(text: title, icon: icon);
}
