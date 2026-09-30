import 'package:freezed_annotation/freezed_annotation.dart';

part 'country.freezed.dart';
part 'country.g.dart';

@freezed
abstract class Country with _$Country {
  const factory Country({
    required String code,
    required String name,
    int? population,
  }) = _Country;

  /// Required by freezed before custom getters may be added.
  const Country._();

  factory Country.fromJson(Map<String, Object?> json) =>
      _$CountryFromJson(json);

  String get flagSvg => 'https://flagcdn.com/${code.toLowerCase()}.svg';
}
