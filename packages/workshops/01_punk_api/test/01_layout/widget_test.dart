import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:punk_api/01_layout/app.dart';
import 'package:punk_api/01_layout/routes/master/widgets/punkapi_card.dart';

void main() {
  group('Master route', () {
    testWidgets(
        'should display 10 PunkApiCard widgets children of SingleChildScrollView',
        (WidgetTester tester) async {
      await tester.pumpWidget(PunkApiApp());

      var scrollViewFinder = find.byType(SingleChildScrollView);
      expect(scrollViewFinder, findsOneWidget);

      var cardsFinder = find.descendant(
          of: scrollViewFinder, matching: find.byType(PunkApiCard));

      expect(cardsFinder, findsNWidgets(10));
    });
  });
}
