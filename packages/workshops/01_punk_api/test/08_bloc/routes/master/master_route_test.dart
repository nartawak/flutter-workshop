import 'dart:async';
import 'dart:io' show Platform;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:punk_api/08_bloc/blocs/beers/beer_bloc.dart';
import 'package:punk_api/08_bloc/models/beer.dart';
import 'package:punk_api/08_bloc/repositories/beer_repository.dart';
import 'package:punk_api/08_bloc/routes/master/master_route.dart';
import 'package:punk_api/08_bloc/routes/master/widgets/punkapi_card.dart';

// ignore: must_be_immutable
class MockBeerBloc extends MockBloc<BeerState> implements BeerBloc {}

void main() {
  BeersRepository beersRepository;
  BeerBloc bloc;

  setUp(() {
    bloc = MockBeerBloc();
  });

  group('MasterRoute', () {
    if (Platform.isMacOS) {
      testWidgets('should golden test the AppBar', (WidgetTester tester) async {
        when(bloc.state).thenReturn(BeerFetchInProgressState());
        whenListen<BeerState>(
            bloc, Stream.fromIterable([BeerFetchInProgressState()]));

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider(
              create: (_) => bloc,
              child: MasterRoute(),
            ),
          ),
        );

        await tester.pump(Duration.zero);

        final appBarFinder = find.byType(AppBar);
        expect(appBarFinder, findsOneWidget);

        expect(appBarFinder, matchesGoldenFile('app_bar.png'));
      });
    }

    testWidgets(
        'should display CircularProgressIndicator when beersRepository.getBeers is not resolved',
        (WidgetTester tester) async {
      when(bloc.state).thenReturn(BeerFetchInProgressState());
      whenListen<BeerState>(
          bloc, Stream.fromIterable([BeerFetchInProgressState()]));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => bloc,
            child: MasterRoute(),
          ),
        ),
      );

      await tester.pump(Duration.zero);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'should display an error message when beersRepository.getBeers rejects an FetchDataException',
        (WidgetTester tester) async {
      when(bloc.state).thenReturn(BeerFetchInProgressState());
      whenListen<BeerState>(bloc, Stream.fromIterable([BeerFetchErrorState()]));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => bloc,
            child: MasterRoute(),
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
        when(bloc.state).thenReturn(BeerFetchInProgressState());
        whenListen<BeerState>(
            bloc,
            Stream.fromIterable(
              [
                BeerFetchSuccessState(
                  beers: [
                    Beer(
                        id: 1,
                        name: 'mock_name',
                        imageURL: 'https://images.punkapi.com/v2/keg.png',
                        tagline: 'mock_tagline'),
                  ],
                ),
              ],
            ));

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider(
              create: (_) => bloc,
              child: MasterRoute(),
            ),
          ),
        );

        await tester.pump(Duration.zero);

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
