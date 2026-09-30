class Country {
  Country({
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
  flagSvg:
      'https://en.wikipedia.org/wiki/Belgium#/media/File:Flag_of_Belgium.svg',
);
final germany = Country(
  code: 'DE',
  name: 'Germany',
  population: 83467117,
  flagSvg:
      'https://en.wikipedia.org/wiki/Germany#/media/File:Flag_of_Germany.svg',
);
final netherlands = Country(
  code: 'NL',
  name: 'Netherlands',
  population: 18130208,
  flagSvg:
      'https://en.wikipedia.org/wiki/Netherlands#/media/File:Flag_of_the_Netherlands.svg',
);
final france = Country(
  code: 'FR',
  name: 'France',
  population: 69081996,
  flagSvg:
      'https://en.wikipedia.org/wiki/France#/media/File:Flag_of_France.svg',
);
final luxembourg = Country(
  code: 'LU',
  name: 'Luxembourg',
  population: 693916,
  flagSvg:
      'https://en.wikipedia.org/wiki/Luxembourg#/media/File:Flag_of_Luxembourg.svg',
);
final switzerland = Country(
  code: 'CH',
  name: 'Switzerland',
  population: 9154242,
  flagSvg:
      'https://en.wikipedia.org/wiki/Switzerland#/media/File:Flag_of_Switzerland_(Pantone).svg',
);

final List<Country> allCountries = [
  belgium,
  germany,
  netherlands,
  france,
  luxembourg,
  switzerland,
];
