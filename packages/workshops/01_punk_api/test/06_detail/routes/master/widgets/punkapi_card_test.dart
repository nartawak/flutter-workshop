import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:punk_api/06_detail/models/beer.dart';
import 'package:punk_api/06_detail/routes/master/widgets/punkapi_card.dart';

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
    if (Platform.isMacOS) {
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
    }

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

    testWidgets('should call onBeerSelected when tapped',
        (WidgetTester tester) async {
      mockNetworkImagesFor(() async {
        Beer selectedBeerResult;

        await tester.pumpWidget(
          getMaterialAppLightThemeWrapper(
            child: PunkApiCard(
              key: cardKey,
              beer: mockBeer,
              onBeerSelected: (selectedBeer) {
                selectedBeerResult = selectedBeer;
              },
            ),
          ),
        );

        expect(selectedBeerResult, isNull);

        await tester.tap(find.byKey(PunkApiCard.gestureDetectorKey));
        await tester.pumpAndSettle();

        expect(selectedBeerResult, isNotNull);
      });
    });
  });
}
