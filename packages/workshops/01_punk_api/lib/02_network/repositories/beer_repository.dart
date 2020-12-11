import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:punk_api/02_network/exceptions/custom_exceptions.dart';
import 'package:punk_api/02_network/models/beer.dart';

const kApiBaseUrl = 'https://api.punkapi.com/v2';
const kBeerResource = 'beer';

@immutable
class BeersRepository {
  final http.Client client;

  BeersRepository({@required this.client}) : assert(client != null);

  Future<List<Beer>> getBeers({
    int pageNumber = 1,
    int itemsPerPage = 10,
  }) async {
    final response = await client.get(
        '$kApiBaseUrl/$kBeerResource?page=$pageNumber&per_page=$itemsPerPage');

    if (response.statusCode != 200) {
      throw FetchDataException(
          'error occurred when fetch beers from punk API: {$response.statusCode}');
    }

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

    return parsed.map<Beer>((json) => Beer.fromJson(json)).toList();
  }
}
