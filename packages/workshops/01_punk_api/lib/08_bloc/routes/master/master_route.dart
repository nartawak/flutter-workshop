import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:punk_api/08_bloc/blocs/blocs.dart';
import 'package:punk_api/08_bloc/routes/detail/detail_route.dart';
import 'package:punk_api/08_bloc/routes/master/widgets/punkapi_card.dart';

class MasterRoute extends StatelessWidget {
  static const routeName = '/';

  MasterRoute({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final image = Image.asset(
      'assets/images/punkapi.png',
      height: 40,
      width: 30,
      fit: BoxFit.fitHeight,
    );

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image,
            const Text(
              'Punk API',
              style: const TextStyle(
                fontFamily: 'Nerko_One',
                fontSize: 40,
              ),
            ),
            image,
          ],
        ),
        backgroundColor: theme.primaryColor,
        centerTitle: true,
      ),
      body: BlocBuilder<BeerBloc, BeerState>(
        builder: (context, state) {
          if (state is BeerFetchErrorState) {
            return Center(
              child: Text('An error occurred'),
            );
          }

          if (state is BeerFetchInProgressState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final beers = (state as BeerFetchSuccessState).beers;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<BeerBloc>()..add(FetchBeersEvent());
              return;
            },
            child: ListView.builder(
              itemCount: beers.length,
              itemBuilder: (_, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: PunkApiCard(
                    beer: beers[index],
                    onBeerSelected: (selectedBeer) {
                      Navigator.pushNamed(context, DetailRoute.routeName,
                          arguments: selectedBeer);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
