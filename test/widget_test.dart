import 'package:flutter_test/flutter_test.dart';

import 'package:voltera/main.dart';

void main() {
  testWidgets('register screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const VolteraApp());

    expect(find.text('Create account'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
  });
}
