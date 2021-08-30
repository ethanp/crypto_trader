class Dollars {
  const Dollars(this.amt);

  final double amt;
}

class Holding {
  const Holding(this.cryptocurrency, this.dollars);

  final Cryptocurrency cryptocurrency;
  final Dollars dollars;
}

class Cryptocurrency {
  const Cryptocurrency({
    required this.name,
    required this.callLetters,
  });

  final String name;
  final String callLetters;
}

const bitcoin = Cryptocurrency(name: 'Bitcoin', callLetters: 'BTC');
const ethereum = Cryptocurrency(name: 'Ethereum', callLetters: 'ETH');
const cardano = Cryptocurrency(name: 'Cardano', callLetters: 'ADA');
const lightcoin = Cryptocurrency(name: 'Lightcoin', callLetters: 'LTC');
const bitcoinCash = Cryptocurrency(name: 'Bitcoin Cash', callLetters: 'BCH');

const supportedCurrencies = [
  bitcoin,
  ethereum,
  cardano,
  lightcoin,
  bitcoinCash,
];
