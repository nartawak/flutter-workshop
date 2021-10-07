import 'package:flutter/material.dart';
import 'package:punk_api/03_listview/models/beer.dart';

class PunkApiCard extends StatelessWidget {
  final Beer beer;

  const PunkApiCard({Key? key, required this.beer});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
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
                  Text(beer.name),
                  Text(beer.tagline!),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
