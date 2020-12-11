import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:punk_api/02_network/repositories/beer_repository.dart';
import 'package:punk_api/02_network/routes/master/master_route.dart';
import 'package:punk_api/02_network/routes/master/widgets/punkapi_card.dart';

// ignore: must_be_immutable
class MockBeerRepository extends Mock implements BeersRepository {}

void main() {
  BeersRepository beersRepository;

  setUp(() {
    beersRepository = MockBeerRepository();
  });

  group('MasterRoute', () {
    testWidgets(
        'should call beersRepository.getBeers on initState lifecycle hook',
        (WidgetTester tester) async {
      when(beersRepository.getBeers()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        MaterialApp(
          home: MasterRoute(
            beersRepository: beersRepository,
          ),
        ),
      );

      verify(beersRepository.getBeers()).called(1);
    });

    testWidgets(
        'should display 10 PunkApiCard widgets children of SingleChildScrollView',
        (WidgetTester tester) async {
      when(beersRepository.getBeers()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        MaterialApp(
          home: MasterRoute(
            beersRepository: beersRepository,
          ),
        ),
      );

      var scrollViewFinder = find.byType(SingleChildScrollView);
      expect(scrollViewFinder, findsOneWidget);

      var cardsFinder = find.descendant(
          of: scrollViewFinder, matching: find.byType(PunkApiCard));

      expect(cardsFinder, findsNWidgets(10));
    });
  });
}
