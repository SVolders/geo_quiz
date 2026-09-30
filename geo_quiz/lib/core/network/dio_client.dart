import "package:dio/dio.dart";

final dio = Dio();

final wantedFields = [
  'names.common',
  'codes.alpha_2'
];

Future<List<Map<String, dynamic>>> getAllCountries() async {
  dio.options.headers['Authorization'] =
      'Bearer rc_live_8a5bb695fa2047e4b229ffe9764c77cf';
  const limit = 100;
  var offset = 0;
  final countries = <Map<String, dynamic>>[];

  while (true) {
    final response = await dio.get<Map<String, dynamic>>(
      'https://api.restcountries.com/countries/v5',
      queryParameters: {
        'memberships.eurozone': 1,
        'classification.un_member': 1,
        'response_fields': wantedFields.join(','),
        'limit': limit,
        'offset': offset,
      },
    );
    final payload = response.data;
    if (payload == null || payload['data'] is! Map) {
      throw const FormatException('Invalid countries API response');
    }

    final data = payload['data'] as Map;
    final objects = data['objects'];
    if (objects is! List) {
      throw const FormatException('Countries API response has no object list');
    }

    for (final object in objects) {
      if (object is Map) {
        countries.add(Map<String, dynamic>.from(object));
      }
    }

    final meta = data['meta'];
    final more = meta is Map && meta['more'] == true;
    if (!more || objects.isEmpty) break;
    offset += objects.length;
  }

  return countries;
}
