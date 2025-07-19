import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/theme/app_theme.dart';
import 'package:expense_tracker/main.dart';

void main() {
  testWidgets('MyApp builds correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: MyApp(),
      ),
    );

    expect(find.text('Expense Tracker'), findsOneWidget);
  });
}