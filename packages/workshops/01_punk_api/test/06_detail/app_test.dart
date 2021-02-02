import 'package:flutter_test/flutter_test.dart';
import 'package:punk_api/06_detail/app.dart';

void main() {
  group('PunkApiApp', () {
    testWidgets('should display PunkApiApp widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(PunkApiApp());

      expect(tester.takeException(), null);
    });
  });
}
