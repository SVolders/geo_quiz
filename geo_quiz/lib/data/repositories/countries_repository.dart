import 'package:geo_quiz/core/network/dio_client.dart';
import 'package:geo_quiz/data/models/country.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'countries_repository.g.dart';

@Riverpod(keepAlive: true)
CountriesRepository countriesRepository(Ref ref) => CountriesRepository();

class CountriesRepository {
  Future<List<Country>> getCountries() async {
    final rows = await getAllCountries();
    return rows.map(_parseCountry).whereType<Country>().toList();
  }

  Country? _parseCountry(Map<String, dynamic> row) {
    final code = (row['codes'] as Map?)?['alpha_2'];
    final name = (row['names'] as Map?)?['common'];

    if (code is! String || code.isEmpty || name is! String || name.isEmpty) {
      return null;
    }

    // `capitals` is a list — a few countries have several, a few have none.
    // Match the first entry's name, or fall through to null.
    final capital = switch (row['capitals']) {
      [{'name': final String first}, ...] when first.isNotEmpty => first,
      _ => null,
    };

    return Country(code: code, name: name, capital: capital);
  }
}
