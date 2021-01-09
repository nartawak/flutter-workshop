import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:punk_api/04_theme_assets/models/beer.dart';
import 'package:punk_api/04_theme_assets/routes/master/widgets/punkapi_card.dart';

import '../../../material_app_theme_wrapper.dart';

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
    testWidgets('should golden test the PunkApiCard with light theme',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          getMaterialAppLightThemeWrapper(
            child: PunkApiCard(
              key: cardKey,
              beer: mockBeer,
            ),
          ),
        );

        final cardFinder = find.byKey(cardKey);
        expect(cardFinder, findsOneWidget);

        await expectLater(
          cardFinder,
          matchesGoldenFile('punkapi_card_light_theme.png'),
        );
      });
    });

    testWidgets('should golden test the PunkApiCard with dark theme',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          getMaterialAppDarkThemeWrapper(
            child: PunkApiCard(
              key: cardKey,
              beer: mockBeer,
            ),
          ),
        );

        final cardFinder = find.byKey(cardKey);
        expect(cardFinder, findsOneWidget);

        await expectLater(
          cardFinder,
          matchesGoldenFile('punkapi_card_dark_theme.png'),
        );
      });
    });
  });

  testWidgets('should display beer name and tagline inside Column',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        getMaterialAppLightThemeWrapper(
          child: PunkApiCard(
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
          matching: find.text(mockBeerName),
        ),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: cardFinder,
          matching: find.text(mockBeerTagline),
        ),
        findsOneWidget,
      );
    });
  });
}
