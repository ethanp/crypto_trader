import 'package:crypto_trader/import_facade/ui_refresher.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/material.dart';

/// Outermost [Scaffold] for the app.
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UiRefresher.register(context);
    final uiTabs = _uiTabs(context);
    return DefaultTabController(
      length: uiTabs.length,
      child: Scaffold(
        appBar: _appBar(uiTabs, context),
        body: TabBarView(children: [...uiTabs.map((t) => t.body)]),
      ),
    );
  }

  List<_TabGo> _uiTabs(BuildContext context) {
    final keyboardIsHidden = MediaQuery.of(context).viewInsets.bottom == 0;
    final uiV1 = _TabGo(
      title: 'OG UI',
      icon: const Icon(Icons.save),
      body: Column(children: [
        HoldingsFacts(),
        TransactionArea(),
        if (keyboardIsHidden) Portfolio(),
      ]),
    );
    final uiV2 = _TabGo(
      title: 'NewNew UI',
      icon: const Icon(Icons.cloud_circle),
      body: Column(children: [
        HoldingsFacts(),
        BuySection(),
        if (keyboardIsHidden) Portfolio(),
      ]),
    );
    return [uiV1, uiV2];
  }

  AppBar _appBar(List<_TabGo> uiTabs, BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 65,
      backgroundColor: Colors.grey[900]!.withBlue(50),
      title: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        indicator: const UnderlineTabIndicator(
          insets: EdgeInsets.only(bottom: 12.0),
        ),
        tabs: [...uiTabs.map((t) => t.asTab)],
      ),
      actions: [_refreshButton(context)],
    );
  }

  Widget _refreshButton(BuildContext context) {
    final icon = Icon(
      Icons.refresh,
      size: 25,
      color: Colors.grey[300]!.withGreen(250),
    );
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

class _TabGo {
  const _TabGo({required this.title, required this.icon, required this.body});

  final String title;
  final Icon icon;
  final Widget body;

  Tab get asTab => Tab(text: title, icon: icon);
}
