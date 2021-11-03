import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Chip at the bottom displaying info about [holdings] of a particular
/// [currency]. When it [isSelected], it is used as the graph currency.
class PortfolioListItem extends StatelessWidget {
  const PortfolioListItem({
    required this.holdings,
    required this.currency,
    required this.isSelected,
  });

  /// Null until it loads.
  final Holdings? holdings;

  final Currency currency;

  final bool isSelected;

  @override
  Widget build(BuildContext context) => SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[900]!),
              borderRadius: BorderRadius.circular(6),
              color: isSelected
                  ? _Style.selectedCardColor
                  : _Style.unselectedCardColor),
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_header(), _wrtPortfolio()]))));

  Widget _header() =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        MyText(holdings?.dollarsOf(currency).toString() ?? 'Loading',
            style: _Style.holdingValueTextStyle, textAlign: TextAlign.right),
        MyText(' of ', style: _Style.ofStyle),
        MyText(currency.name, style: _Style.currencyNameTextStyle),
        const SizedBox(width: 4),
        MyText('(${currency.callLetters})', style: _Style.callLettersTextStyle),
      ]);

  Widget _wrtPortfolio() {
    if (holdings == null) return const CupertinoActivityIndicator();
    // TODO try wrapping this with IntrinsicWidth instead of using SizedBox
    //  https://api.flutter.dev/flutter/widgets/IntrinsicWidth-class.html
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_allocation(), _actual(), _difference()]
            .map((w) => SizedBox(width: 48, child: w))
            .toList());
  }

  Widget _actual() {
    if (holdings == null) return const CupertinoActivityIndicator();
    final actualPercentage = holdings!.percentageContaining(currency).round();
    final percentage =
        MyText('$actualPercentage%', style: _Style.percentagesTextStyle);
    const caption = MyText('actual', style: _Style.caption);
    return Column(children: [percentage, const SizedBox(height: 2), caption]);
  }

  Widget _allocation() {
    final allocation = MyText(
      '${currency.percentAllocation}%',
      style: _Style.percentagesTextStyle,
    );
    const caption = MyText('allocated', style: _Style.caption);
    return Column(children: [allocation, caption]);
  }

  Widget _difference() {
    final difference = holdings!.difference(currency);
    final Color color =
        difference >= 0 ? _Style.overheldColor : _Style.underheldColor;
    final diffText =
        MyText('${difference.round()}%', style: _Style.differenceStyle(color));
    final caption = MyText(
      difference >= 0 ? 'overheld' : 'underheld',
      style: _Style.caption,
    );
    return Column(children: [diffText, caption]);
  }
}

class _Style {
  static TextStyle differenceStyle(Color color) =>
      percentagesTextStyle.copyWith(color: color);

  static const underheldColor = Colors.green;
  static const overheldColor = Colors.red;
  static final unselectedCardColor = Colors.grey[900]!.withOpacity(.5);
  static final selectedCardColor = Colors.grey[800]!;
  static final greyText = TextStyle(color: Colors.grey[500]);
  static final greenText = TextStyle(color: Colors.green[300]);
  static const heavyWeight = TextStyle(fontWeight: FontWeight.w700);
  static const mediumWeight = TextStyle(fontWeight: FontWeight.w500);
  static const textSize = TextStyle(fontSize: 14);
  static const tight = TextStyle(letterSpacing: -1);

  static const caption = TextStyle(
    fontSize: 9,
    color: Color.fromRGBO(150, 200, 255, 1),
  );
  static final callLettersTextStyle =
      textSize.merge(heavyWeight).merge(greyText);
  static final currencyNameTextStyle = textSize.merge(tight);
  static final percentagesTextStyle = greyText.merge(mediumWeight);
  static final holdingValueTextStyle =
      textSize.merge(mediumWeight).merge(greenText);
  static final ofStyle = textSize.merge(greyText);
}
