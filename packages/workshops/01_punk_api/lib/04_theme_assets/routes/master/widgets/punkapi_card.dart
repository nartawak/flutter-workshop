import 'package:flutter/material.dart';
import 'package:punk_api/04_theme_assets/models/beer.dart';

class PunkApiCard extends StatelessWidget {
  final Beer beer;

  const PunkApiCard({
    Key? key,
    required this.beer,
  })  : assert(beer != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
    );
  }
}
