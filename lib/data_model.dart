class Dollars {
  const Dollars(this.amt);

  final double amt;
}

class Holding {
  const Holding(this.currency, this.dollars);

  final Currency currency;
  final Dollars dollars;
}

class Currency {
  const Currency({
    required this.name,
    required this.callLetters,
  });

  final String name;
  final String callLetters;
}

const bitcoin = Currency(name: 'Bitcoin', callLetters: 'BTC');
const bitcoinCash = Currency(name: 'Bitcoin Cash', callLetters: 'BCH');
const cardano = Currency(name: 'Cardano', callLetters: 'ADA');
const dollars = Currency(name: 'US Dollars', callLetters: 'USD');
const ethereum = Currency(name: 'Ethereum', callLetters: 'ETH');
const lightcoin = Currency(name: 'Lightcoin', callLetters: 'LTC');

const supportedCurrencies = [
  bitcoin,
  bitcoinCash,
  cardano,
  dollars,
  ethereum,
  lightcoin,
];
