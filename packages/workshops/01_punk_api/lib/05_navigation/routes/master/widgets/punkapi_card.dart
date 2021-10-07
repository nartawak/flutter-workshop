import 'package:flutter/material.dart';
import 'package:punk_api/05_navigation/models/beer.dart';

typedef SelectedBeer = void Function(Beer beer);

class PunkApiCard extends StatelessWidget {
  static const gestureDetectorKey = Key('gestureDetectorKey');

  final Beer beer;
  final SelectedBeer? onBeerSelected;

  const PunkApiCard({
    Key? key,
    required this.beer,
    this.onBeerSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      key: gestureDetectorKey,
      onTap: () {
        if (onBeerSelected != null) {
          onBeerSelected!(beer);
        }
      },
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.4),
              offset: const Offset(0.0, 1.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              child: Image.network(
                beer.imageURL,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      beer.name,
                      style: theme.textTheme.headline6,
                    ),
                    Text(
                      beer.tagline!,
                      style: theme.textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
