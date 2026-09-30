import 'package:freezed_annotation/freezed_annotation.dart';

part 'country.freezed.dart';

@freezed
class Country ({
    required final String code,
    required final String name,
    final int? population,
    final String? flagSvg,
}) with  _$Country;