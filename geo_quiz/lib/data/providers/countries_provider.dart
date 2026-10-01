import 'package:geo_quiz/data/models/country.dart';
import 'package:geo_quiz/data/repositories/countries_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'countries_provider.g.dart';

/// The full country list, fetched once and kept for the lifetime of the app.
///
/// `keepAlive` is the cache: without it the list is dropped whenever nothing
/// watches it, and the next watcher refetches all three pages.
@Riverpod(keepAlive: true)
Future<List<Country>> countries(Ref ref) =>
    ref.watch(countriesRepositoryProvider).getCountries();
