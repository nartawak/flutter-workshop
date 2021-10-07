import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:punk_api/02_network/exceptions/custom_exceptions.dart';
import 'package:punk_api/02_network/models/beer.dart';

const kApiBaseUrl = 'api.punkapi.com';
const kBeerResource = '/v2/beers';

@immutable
class BeersRepository {
  final http.Client client;

  BeersRepository({required this.client});

  Future<List<Beer>?> getBeers({
    int pageNumber = 1,
    int itemsPerPage = 10,
  }) async {
    var urlToCall = Uri.https('$kApiBaseUrl', '$kBeerResource',
        {'page': '$pageNumber', 'per_page': '$itemsPerPage'});
    final response = await client.get(urlToCall);

    if (response.statusCode != 200) {
      return Future.error(FetchDataException(
          'error occurred when fetch beers from punk API: {$response.statusCode}'));
    }

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

    return parsed.map<Beer>((json) => Beer.fromJson(json)).toList();
  }
}
