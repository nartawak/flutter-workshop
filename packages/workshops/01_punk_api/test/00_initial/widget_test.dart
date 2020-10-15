import 'package:flutter_test/flutter_test.dart';
import 'package:punk_api/01_layout/app.dart';

void main() {
  testWidgets('Master route', (WidgetTester tester) async {
    await tester.pumpWidget(PunkApiApp());

    expect(find.text('Master route'), findsOneWidget);
  });
}
