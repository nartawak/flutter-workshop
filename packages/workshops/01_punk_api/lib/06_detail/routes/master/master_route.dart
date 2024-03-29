import 'package:flutter/material.dart';
import 'package:punk_api/06_detail/repositories/beer_repository.dart';
import 'package:punk_api/06_detail/routes/detail/detail_route.dart';
import 'package:punk_api/06_detail/routes/master/widgets/punkapi_card.dart';

class MasterRoute extends StatelessWidget {
  static const routeName = '/';

  final BeersRepository beersRepository;

  MasterRoute({required this.beersRepository});

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
      body: FutureBuilder(
        future: beersRepository.getBeers(itemsPerPage: 80),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final beers = snapshot.data;

          return ListView.builder(
            itemCount: (beers as List).length,
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
          );
        },
      ),
    );
  }
}
