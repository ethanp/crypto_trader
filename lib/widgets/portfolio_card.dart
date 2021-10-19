import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Chip at the bottom displaying info about [holdings] of a particular
/// [currency]. When it [isSelected], it is used as the graph currency.
class PortfolioCard extends StatelessWidget {
  /// Create a chip at the bottom displaying info about [holdings] of a
  /// particular [currency].
  const PortfolioCard({
    required this.holdings,
    required this.currency,
    required this.isSelected,
  });

  /// Null until it loads.
  final Holdings? holdings;

  final Currency currency;

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.05,
      child: Card(
        elevation: isSelected ? 0 : 10,
        color:
            isSelected ? _Style.selectedCardColor : _Style.unselectedCardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_name(), _percentageOfPortfolio()]
                .map(
                  (elem) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: elem,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _name() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _holding(),
        MyText(' of ', style: _Style.ofStyle),
        MyText(currency.name, style: _Style.currencyNameTextStyle),
        const SizedBox(width: 4),
        MyText('(${currency.callLetters})', style: _Style.callLettersTextStyle),
      ],
    );
  }

  Widget _holding() => MyText(
        holdings?.dollarsOf(currency).toString() ?? 'Loading',
        style: _Style.holdingValueTextStyle,
      );

  Widget _percentageOfPortfolio() {
    if (holdings == null) return const CupertinoActivityIndicator();
    final actualPercentage = holdings!.percentageContaining(currency).round();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            MyText(
              '${currency.percentAllocation}%',
              style: _Style.percentagesTextStyle,
            ),
            const MyText('Allocated', style: _Style.caption),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            MyText(
              '$actualPercentage%',
              style: _Style.percentagesTextStyle,
            ),
            const MyText('Actual', style: _Style.caption),
          ],
        ),
        const SizedBox(width: 10),
        _difference(),
      ],
    );
  }

  Widget _difference() {
    final difference = holdings!.difference(currency);
    final Color color =
        difference >= 0 ? _Style.overheldColor : _Style.underheldColor;
    return Column(
      children: [
        MyText('${difference.round()}%', style: _Style.differenceStyle(color)),
        MyText(
          difference >= 0 ? 'overheld' : 'underheld',
          style: _Style.caption,
        ),
      ],
    );
  }
}

class _Style {
  static TextStyle differenceStyle(Color color) =>
      percentagesTextStyle.copyWith(color: color);

  static const underheldColor = Colors.green;
  static final overheldColor = Colors.red;
  static final unselectedCardColor = Colors.grey[800];
  static final selectedCardColor = Colors.grey[700];
  static final darkerText = TextStyle(color: Colors.grey[500]);
  static final greenText = TextStyle(color: Colors.green[300]);
  static const heavyWeight = TextStyle(fontWeight: FontWeight.w700);
  static const mediumWeight = TextStyle(fontWeight: FontWeight.w500);
  static const textSize = TextStyle(fontSize: 12);
  static const tight = TextStyle(letterSpacing: -1);

  static const caption = TextStyle(
    fontSize: 8,
    color: Color.fromRGBO(150, 200, 255, 1),
  );
  static final callLettersTextStyle =
      textSize.merge(heavyWeight).merge(darkerText);
  static final currencyNameTextStyle = textSize.merge(tight);
  static final percentagesTextStyle = darkerText.merge(mediumWeight);
  static final holdingValueTextStyle =
      textSize.merge(mediumWeight).merge(greenText);
  static final ofStyle = textSize.merge(darkerText);
}
