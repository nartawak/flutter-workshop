import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:punk_api/04_theme_assets/exceptions/custom_exceptions.dart';
import 'package:punk_api/04_theme_assets/models/beer.dart';
import 'package:punk_api/04_theme_assets/repositories/beer_repository.dart';
import 'package:punk_api/04_theme_assets/routes/master/master_route.dart';
import 'package:punk_api/04_theme_assets/routes/master/widgets/punkapi_card.dart';

// ignore: must_be_immutable
class MockBeerRepository extends Mock implements BeersRepository {}

void main() {
  BeersRepository beersRepository;

  setUp(() {
    beersRepository = MockBeerRepository();
  });

  group('MasterRouteStateful', () {
    testWidgets(
        'should call beersRepository.getBeers on initState lifecycle hook',
        (WidgetTester tester) async {
      when(
        beersRepository.getBeers(),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(
        MaterialApp(
          home: MasterRouteStateful(
            beersRepository: beersRepository,
          ),
        ),
      );

      verify(
        beersRepository.getBeers(pageNumber: 1, itemsPerPage: 80),
      ).called(1);
    });

    testWidgets(
        'should display CircularProgressIndicator when beersRepository.getBeers is not resolved',
        (WidgetTester tester) async {
      Completer completer = Completer();
      when(
        beersRepository.getBeers(),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(
        MaterialApp(
          home: MasterRouteStateful(
            beersRepository: beersRepository,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'should display an error message when beersRepository.getBeers rejects an FetchDataException',
        (WidgetTester tester) async {
      when(
        beersRepository.getBeers(
          pageNumber: 1,
          itemsPerPage: 80,
        ),
      ).thenAnswer((_) => Future.error(FetchDataException()));

      await tester.pumpWidget(
        MaterialApp(
          home: MasterRouteStateful(
            beersRepository: beersRepository,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('An error occurred'), findsOneWidget);
    });

    testWidgets(
        'should display ListView with 1 PunkApiCard when beersRepository.getBeers resolved with a list of 1 Beer',
        (WidgetTester tester) async {
      mockNetworkImagesFor(() async {
        Completer completer = Completer<List<Beer>>();
        when(beersRepository.getBeers(pageNumber: 1, itemsPerPage: 80))
            .thenAnswer((_) => completer.future);

        await tester.pumpWidget(
          MaterialApp(
            home: MasterRouteStateful(
              beersRepository: beersRepository,
            ),
          ),
        );

        completer.complete([
          Beer(
              id: 1,
              name: 'mock_name',
              imageURL: 'https://images.punkapi.com/v2/keg.png',
              tagline: 'mock_tagline'),
        ]);
        await tester.pumpAndSettle();

        var listFinder = find.byType(ListView);
        expect(listFinder, findsOneWidget);

        expect(
          find.descendant(of: listFinder, matching: find.byType(PunkApiCard)),
          findsOneWidget,
        );
      });
    });
  });

  group('MasterRouteFutureBuilder', () {
    testWidgets(
        'should display CircularProgressIndicator when beersRepository.getBeers is not resolved',
        (WidgetTester tester) async {
      Completer completer = Completer();
      when(
        beersRepository.getBeers(),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(
        MaterialApp(
          home: MasterRouteFutureBuilder(
            beersRepository: beersRepository,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'should display an error message when beersRepository.getBeers rejects an FetchDataException',
        (WidgetTester tester) async {
      when(
        beersRepository.getBeers(
          pageNumber: 1,
          itemsPerPage: 80,
        ),
      ).thenAnswer((_) => Future.error(FetchDataException()));

      await tester.pumpWidget(
        MaterialApp(
          home: MasterRouteFutureBuilder(
            beersRepository: beersRepository,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('An error occurred'), findsOneWidget);
    });

    testWidgets(
        'should display ListView with 1 PunkApiCard when beersRepository.getBeers resolved with a list of 1 Beer',
        (WidgetTester tester) async {
      mockNetworkImagesFor(() async {
        Completer completer = Completer<List<Beer>>();
        when(beersRepository.getBeers(pageNumber: 1, itemsPerPage: 80))
            .thenAnswer((_) => completer.future);

        await tester.pumpWidget(
          MaterialApp(
            home: MasterRouteFutureBuilder(
              beersRepository: beersRepository,
            ),
          ),
        );

        completer.complete([
          Beer(
              id: 1,
              name: 'mock_name',
              imageURL: 'https://images.punkapi.com/v2/keg.png',
              tagline: 'mock_tagline'),
        ]);
        await tester.pumpAndSettle();

        var listFinder = find.byType(ListView);
        expect(listFinder, findsOneWidget);

        expect(
          find.descendant(of: listFinder, matching: find.byType(PunkApiCard)),
          findsOneWidget,
        );
      });
    });
  });
}
