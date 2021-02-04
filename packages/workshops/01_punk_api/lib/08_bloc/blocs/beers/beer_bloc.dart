import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:punk_api/08_bloc/models/beer.dart';
import 'package:punk_api/08_bloc/repositories/beer_repository.dart';

part 'beer_event.dart';
part 'beer_state.dart';

class BeerBloc extends Bloc<BeerEvent, BeerState> {
  final BeersRepository beersRepository;

  BeerBloc({@required this.beersRepository})
      : assert(beersRepository != null),
        super(BeerFetchInProgressState());

  @override
  Stream<BeerState> mapEventToState(
    BeerEvent event,
  ) async* {
    if (event is FetchBeersEvent) {
      yield* _mapFetchBeersEventToState();
    }
  }

  Stream<BeerState> _mapFetchBeersEventToState() async* {
    try {
      yield BeerFetchInProgressState();
      final beers = await this.beersRepository.getBeers();
      yield BeerFetchSuccessState(beers: beers ?? []);
    } catch (e) {
      yield BeerFetchErrorState();
    }
  }
}
