import 'package:crypto_trader/import_facade/model.dart';
import 'package:crypto_trader/import_facade/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// One of those little chips at the bottom displaying info about [holdings]
/// of a particular [currency], and showing whether or not it [isSelected].
class PortfolioCard extends StatelessWidget {
  /// One of those little chips at the bottom displaying info about [holdings]
  /// of a particular [currency], and showing whether or not it [isSelected].
  const PortfolioCard({
    required this.holdings,
    required this.currency,
    required this.isSelected,
  });

  /// Once loaded, contains full info about current user's holdings.
  /// Before loading, just null.
  final Holdings? holdings;

  /// Which [Currency] is reflected in this [PortfolioCard].
  final Currency currency;

  /// Whether the user ha selected this [PortfolioCard] (by tapping on it).
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 0 : 10,
      color: isSelected ? _Style.selectedCardColor : _Style.unselectedCardColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _name(),
          _holding(),
          _percentageOfPortfolio(),
        ],
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

  static final underheldColor = Colors.green;
  static final overheldColor = Colors.red;
  static final unselectedCardColor = Colors.grey[800];
  static final selectedCardColor = Colors.grey[700];
  static final darkerText = TextStyle(color: Colors.grey[500]);
  static final lighterText = TextStyle(color: Colors.grey[300]);
  static const heavyWeight = TextStyle(fontWeight: FontWeight.w700);
  static const mediumWeight = TextStyle(fontWeight: FontWeight.w500);
  static const smallText = TextStyle(fontSize: 17);
  static const largeText = TextStyle(fontSize: 20);

  static final callLettersTextStyle =
      smallText.merge(heavyWeight).merge(darkerText);
  static const currencyNameTextStyle = smallText;
  static final percentagesTextStyle = lighterText.merge(mediumWeight);
  static final holdingValueTextStyle =
      largeText.merge(mediumWeight).merge(lighterText);
}
