class Country {
  const Country({
    required this.code,
    required this.name,
    this.population,
    this.flagSvg,
  });

  final String code;
  final String name;
  final int? population;
  final String? flagSvg;
}

final belgium = Country(
  code: 'BE',
  name: 'Belgium',
  population: 11867634,
  flagSvg: 'https://flagcdn.com/be.svg',
);
final germany = Country(
  code: 'DE',
  name: 'Germany',
  population: 83467117,
  flagSvg: 'https://flagcdn.com/de.svg',
);
final netherlands = Country(
  code: 'NL',
  name: 'Netherlands',
  population: 18130208,
  flagSvg: 'https://flagcdn.com/nl.svg',
);
final france = Country(
  code: 'FR',
  name: 'France',
  population: 69081996,
  flagSvg: 'https://flagcdn.com/fr.svg',
);
final luxembourg = Country(
  code: 'LU',
  name: 'Luxembourg',
  population: 693916,
  flagSvg: 'https://flagcdn.com/lu.svg',
);
final switzerland = Country(
  code: 'CH',
  name: 'Switzerland',
  population: 9154242,
  flagSvg: 'https://flagcdn.com/ch.svg',
);

final List<Country> allCountries = [
  belgium,
  germany,
  netherlands,
  france,
  luxembourg,
  switzerland,
];
