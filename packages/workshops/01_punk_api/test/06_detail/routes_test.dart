import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:punk_api/06_detail/models/beer.dart';
import 'package:punk_api/06_detail/repositories/beer_repository.dart';
import 'package:punk_api/06_detail/routes/detail/detail_route.dart';
import 'package:punk_api/06_detail/routes/master/master_route.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

final _mockNavigatorKey = GlobalKey<NavigatorState>();
const _mockBeerName = 'beer_name';
const _mockBeerTagline = 'beer_tagline';
final _mockBeer = Beer(
  id: 1,
  name: _mockBeerName,
  tagline: _mockBeerTagline,
  imageURL: 'https://images.punkapi.com/v2/keg.png',
);

void main() {
  group('Navigation', () {
    NavigatorObserver _mockObserver;
    MaterialApp _mockMaterialApp;

    setUp(() {
      _mockObserver = MockNavigatorObserver();
      _mockMaterialApp = MaterialApp(
        title: 'Flutter Demo',
        navigatorKey: _mockNavigatorKey,
        navigatorObservers: [_mockObserver],
        initialRoute: MasterRoute.routeName,
        routes: {
          MasterRoute.routeName: (_) => MasterRoute(
                beersRepository: BeersRepository(
                  client: http.Client(),
                ),
              ),
          DetailRoute.routeName: (_) => DetailRoute(),
        },
      );
    });

    testWidgets('should initialize application on MasterRoute',
        (WidgetTester tester) async {
      await tester.pumpWidget(_mockMaterialApp);

      expect(find.byType(MasterRoute), findsOneWidget);
      verify(_mockObserver.didPush(any, any));
    });

    testWidgets('should navigate on DetailRoute', (WidgetTester tester) async {
      await tester.pumpWidget(_mockMaterialApp);

      // MasterRoute
      verify(_mockObserver.didPush(any, any));

      _mockNavigatorKey.currentState
          .pushNamed(DetailRoute.routeName, arguments: _mockBeer);

      await tester.pumpAndSettle();

      expect(find.byType(DetailRoute), findsOneWidget);
      expect(find.text(_mockBeerName), findsOneWidget);
      verify(_mockObserver.didPush(any, any));
    });
  });
}
