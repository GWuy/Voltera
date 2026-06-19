import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voltera/features/auth/presentation/register_screen.dart';

void main() {
  testWidgets('Register screen loads', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegisterScreen(),
      ),
    );

    expect(find.text('Register'), findsOneWidget);
  });
}