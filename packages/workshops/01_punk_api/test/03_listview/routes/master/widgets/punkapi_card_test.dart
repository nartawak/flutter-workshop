import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:punk_api/03_listview/models/beer.dart';
import 'package:punk_api/03_listview/routes/master/widgets/punkapi_card.dart';

const mockBeerName = 'beer_name';
const mockBeerTagline = 'beer_tagline';
final mockBeer = Beer(
  id: 1,
  name: mockBeerName,
  tagline: mockBeerTagline,
  imageURL: 'https://images.punkapi.com/v2/keg.png',
);

final cardKey = GlobalKey();

void main() {
  group('PunkApiCard', () {
    testWidgets('should display image', (WidgetTester tester) async {
      mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: PunkApiCard(
              key: cardKey,
              beer: mockBeer,
            ),
          ),
        );

        final cardFinder = find.byKey(cardKey);
        expect(cardFinder, findsOneWidget);

        expect(
            find.descendant(
              of: cardFinder,
              matching: find.byType(Image),
            ),
            findsOneWidget);
      });
    });

    testWidgets('should display beer name and tagline inside Column',
        (WidgetTester tester) async {
      mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: PunkApiCard(
              key: cardKey,
              beer: mockBeer,
            ),
          ),
        );

        final cardFinder = find.byKey(cardKey);
        expect(cardFinder, findsOneWidget);

        var columnFinder = find.descendant(
          of: cardFinder,
          matching: find.byType(Column),
        );
        expect(columnFinder, findsOneWidget);

        expect(
          find.descendant(
            of: columnFinder,
            matching: find.text(mockBeerName),
          ),
          findsOneWidget,
        );

        expect(
          find.descendant(
            of: columnFinder,
            matching: find.text(mockBeerTagline),
          ),
          findsOneWidget,
        );
      });
    });
  });
}
