class Country {
  final String name;
  final String flagAsset;
  final String dialCode;

  Country({
    required this.name,
    required this.flagAsset,
    required this.dialCode,
  });
}

final List<Country> countryList = [
  Country(name: 'Việt Nam', flagAsset: 'assets/flags/VN.png', dialCode: '+84'),
  Country(name: 'Việt Nam', flagAsset: 'assets/flags/VN.png', dialCode: '+84'),
  Country(name: 'Việt Nam', flagAsset: 'assets/flags/VN.png', dialCode: '+84'),
  Country(name: 'Việt Nam', flagAsset: 'assets/flags/VN.png', dialCode: '+84'),
];
