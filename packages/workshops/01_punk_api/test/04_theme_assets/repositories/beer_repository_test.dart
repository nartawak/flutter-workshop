import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:punk_api/04_theme_assets/exceptions/custom_exceptions.dart';
import 'package:punk_api/04_theme_assets/repositories/beer_repository.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late http.Client mockClient;
  late BeersRepository beersRepository;
  var urlToCall = Uri.https('$kApiBaseUrl', '$kBeerResource', {'page': '1','per_page': '10' });

  setUp(() {
    mockClient = MockHttpClient();
    beersRepository = BeersRepository(client: mockClient);
  });

  group('getBeers', () {
    test(
        'should throw a FetchDataException when response.statusCode is not 200',
        () async {
      when(mockClient.get(urlToCall))
          .thenAnswer((_) async => http.Response("mock_body", 400));

      expect(
          beersRepository.getBeers(),
          // You can find full list of matchers => https://api.flutter.dev/flutter/package-matcher_matcher/package-matcher_matcher-library.html
          throwsA(predicate((dynamic e) => e is FetchDataException)));
    });

    test('should return a list of beer with one beer', () async {
      const mockJson =
          "[{\"id\":1,\"name\":\"Buzz\",\"tagline\":\"A Real Bitter Experience.\",\"description\":\"A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once.\",\"image_url\":\"https:\/\/images.punkapi.com\/v2\/keg.png\"}]";
      when(mockClient.get(urlToCall))
          .thenAnswer((_) async => http.Response(mockJson, 200));

      final beers = await (beersRepository.getBeers() as FutureOr<List<Beer>>);
      expect(beers, isList);
      expect(beers.length, 1);

      final first = beers[0];
      expect(first.id, 1);
      expect(first.name, 'Buzz');
    });
  });
}
