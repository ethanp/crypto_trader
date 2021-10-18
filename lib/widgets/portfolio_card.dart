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
      width: MediaQuery.of(context).size.width / 2.2,
      child: Card(
        elevation: isSelected ? 0 : 10,
        color:
            isSelected ? _Style.selectedCardColor : _Style.unselectedCardColor,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_name(), _holding(), _percentageOfPortfolio()]
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
        MyText(currency.callLetters, style: _Style.callLettersTextStyle),
        const SizedBox(width: 10),
        MyText(currency.name, style: _Style.currencyNameTextStyle),
      ],
    );
  }

  Widget _holding() => MyText(
        holdings?.dollarsOf(currency).toString() ?? 'Loading',
        style: _Style.holdingValueTextStyle,
      );

  Widget _percentageOfPortfolio() {
    if (holdings == null) return const CupertinoActivityIndicator();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _percentages(),
        const SizedBox(width: 10),
        _difference(),
      ],
    );
  }

  Widget _percentages() {
    final actualPercentage = holdings!.percentageContaining(currency).round();
    return MyText(
      '$actualPercentage% / ${currency.percentAllocation}%',
      style: _Style.percentagesTextStyle,
    );
  }

  Widget _difference() {
    final difference = holdings!.difference(currency);
    final Color color =
        difference >= 0 ? _Style.overheldColor : _Style.underheldColor;
    return MyText('${difference.round()}%',
        style: _Style.differenceStyle(color));
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
  static final lighterText = TextStyle(color: Colors.grey[300]);
  static const heavyWeight = TextStyle(fontWeight: FontWeight.w700);
  static const mediumWeight = TextStyle(fontWeight: FontWeight.w500);
  static const smallText = TextStyle(fontSize: 17);
  static const largeText = TextStyle(fontSize: 18);
  static const tight = TextStyle(letterSpacing: -1);

  static final callLettersTextStyle =
      smallText.merge(heavyWeight).merge(darkerText);
  static final currencyNameTextStyle = smallText.merge(tight);
  static final percentagesTextStyle = darkerText.merge(mediumWeight);
  static final holdingValueTextStyle =
      largeText.merge(mediumWeight).merge(lighterText);
}
