import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:punk_api/06_detail/exceptions/custom_exceptions.dart';
import 'package:punk_api/06_detail/models/beer.dart';
import 'package:punk_api/06_detail/repositories/beer_repository.dart';
import 'package:punk_api/06_detail/routes/master/master_route.dart';
import 'package:punk_api/06_detail/routes/master/widgets/punkapi_card.dart';

// ignore: must_be_immutable
class MockBeerRepository extends Mock implements BeersRepository {}

void main() {
  BeersRepository beersRepository;

  setUp(() {
    beersRepository = MockBeerRepository();
  });

  group('MasterRoute', () {
    if (Platform.isMacOS) {
      testWidgets('should golden test the AppBar', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MasterRoute(
              beersRepository: beersRepository,
            ),
          ),
        );

        final appBarFinder = find.byType(AppBar);
        expect(appBarFinder, findsOneWidget);

        await expectLater(appBarFinder, matchesGoldenFile('app_bar.png'));
      });
    }

    testWidgets(
        'should display CircularProgressIndicator when beersRepository.getBeers is not resolved',
        (WidgetTester tester) async {
      Completer completer = Completer();
      when(
        beersRepository.getBeers(),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(
        MaterialApp(
          home: MasterRoute(
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
          home: MasterRoute(
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
            home: MasterRoute(
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
