import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:punk_api/08_bloc/blocs/beers/beer_bloc.dart';
import 'package:punk_api/08_bloc/exceptions/custom_exceptions.dart';
import 'package:punk_api/08_bloc/repositories/beer_repository.dart';

// ignore: must_be_immutable
class MockBeerRepository extends Mock implements BeersRepository {}

void main() {
  BeersRepository beersRepository;

  setUp(() {
    beersRepository = MockBeerRepository();
  });

  group('BeerBloc', () {
    test('should test initial state', () {
      expect(
        BeerBloc(beersRepository: beersRepository).state,
        isA<BeerFetchInProgressState>(),
      );
    });

    blocTest(
      'emit [] when nothing is called',
      build: () => BeerBloc(beersRepository: beersRepository),
      expect: const <BeerState>[],
    );

    blocTest(
      'emit [BeerFetchInProgressState, BeerFetchSuccessState] when FetchBeersEvent is called',
      build: () => BeerBloc(beersRepository: beersRepository),
      act: (bloc) async => bloc.add(FetchBeersEvent()),
      expect: const <BeerState>[
        BeerFetchInProgressState(),
        BeerFetchSuccessState()
      ],
    );

    blocTest(
      'emit [BeerFetchInProgressState, BeerFetchErrorState] when FetchBeersEvent is called',
      build: () {
        when(
          beersRepository.getBeers(
            pageNumber: 1,
            itemsPerPage: 80,
          ),
        ).thenAnswer((_) => Future.error(FetchDataException()));
        return BeerBloc(beersRepository: beersRepository);
      },
      act: (bloc) async => bloc.add(FetchBeersEvent()),
      expect: [isA<BeerFetchInProgressState>(), isA<BeerFetchErrorState>()],
    );
  });
}
