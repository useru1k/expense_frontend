class CurrencyOption {
  const CurrencyOption({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
  });

  final String code;
  final String name;
  final String symbol;
  final String flag;

  String get displayName => '$name ($code)';

  static const usd = CurrencyOption(
    code: 'USD',
    name: 'US Dollar',
    symbol: '\$',
    flag: '🇺🇸',
  );
  static const inr = CurrencyOption(
    code: 'INR',
    name: 'Indian Rupee',
    symbol: '₹',
    flag: '🇮🇳',
  );
  static const eur = CurrencyOption(
    code: 'EUR',
    name: 'Euro',
    symbol: '€',
    flag: '🇪🇺',
  );
  static const gbp = CurrencyOption(
    code: 'GBP',
    name: 'British Pound',
    symbol: '£',
    flag: '🇬🇧',
  );
  static const jpy = CurrencyOption(
    code: 'JPY',
    name: 'Japanese Yen',
    symbol: '¥',
    flag: '🇯🇵',
  );
  static const aud = CurrencyOption(
    code: 'AUD',
    name: 'Australian Dollar',
    symbol: 'A\$',
    flag: '🇦🇺',
  );
  static const cad = CurrencyOption(
    code: 'CAD',
    name: 'Canadian Dollar',
    symbol: 'C\$',
    flag: '🇨🇦',
  );
  static const sgd = CurrencyOption(
    code: 'SGD',
    name: 'Singapore Dollar',
    symbol: 'S\$',
    flag: '🇸🇬',
  );
  static const aed = CurrencyOption(
    code: 'AED',
    name: 'UAE Dirham',
    symbol: 'د.إ',
    flag: '🇦🇪',
  );
  static const chf = CurrencyOption(
    code: 'CHF',
    name: 'Swiss Franc',
    symbol: 'CHF',
    flag: '🇨🇭',
  );

  static const all = <CurrencyOption>[
    usd,
    inr,
    eur,
    gbp,
    jpy,
    aud,
    cad,
    sgd,
    aed,
    chf,
  ];
}
