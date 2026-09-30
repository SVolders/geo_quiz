import 'package:freezed_annotation/freezed_annotation.dart';

part 'country.freezed.dart';

@freezed
class Country({
  required final String code,
  required final String name,
  required final String flagSvg,
  final int? population,
}) with _$Country;
