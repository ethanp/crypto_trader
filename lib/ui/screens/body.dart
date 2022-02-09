import 'package:crypto_trader/import_facade/ui.dart';
import 'package:crypto_trader/ui/util/ui_refresher.dart';
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

  // There's currently just one tab, but in the future, when we need a new tab,
  // leaving the infra there will make it trivial (rather than pretty annoying).
  List<_TabGo> _uiTabs(BuildContext context) {
    final keyboardIsHidden = MediaQuery.of(context).viewInsets.bottom == 0;
    final uiV2 = _TabGo(
      title: 'Make money, get money',
      body: Column(children: [
        HoldingsFacts(),
        TransactionArea(BuySection()),
        if (keyboardIsHidden) Portfolio(),
      ]),
    );
    return [uiV2];
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
  const _TabGo({required this.title, required this.body});

  final String title;
  final Widget body;

  Tab get asTab => Tab(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: MyText(title, style: const TextStyle(fontSize: 15)),
      ));
}
