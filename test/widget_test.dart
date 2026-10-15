import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heera_organics/core/widgets/app_button.dart';

void main() {
  testWidgets('AppButton renders correct text and handles tap', (
    WidgetTester tester,
  ) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            text: 'Explore Fresh Catalogue',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Explore Fresh Catalogue'), findsOneWidget);
    await tester.tap(find.text('Explore Fresh Catalogue'));
    expect(tapped, isTrue);
  });
}
