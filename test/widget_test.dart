import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

void main() {
  testWidgets('App launches without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const EmergencyAlertApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
