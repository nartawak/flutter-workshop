part of 'beer_bloc.dart';

abstract class BeerState extends Equatable {
  const BeerState();

  @override
  List<Object> get props => [];
}

class BeerFetchInProgressState extends BeerState {
  const BeerFetchInProgressState();
}

class BeerFetchSuccessState extends BeerState {
  final List<Beer> beers;

  const BeerFetchSuccessState({this.beers = const []});
}

class BeerFetchErrorState extends BeerState {
  const BeerFetchErrorState();
}
