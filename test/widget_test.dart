import 'package:fitness_kolkata/app.dart';
import 'package:fitness_kolkata/viewmodels/plan_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Fitness app loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => PlanViewModel())],
        child: const FitnessApp(),
      ),
    );

    expect(find.text('FITNESS KOLKATA'), findsOneWidget);
    expect(
      find.text('Transform Your Body, Transform Your Life'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.fitness_center), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text('Today\'s Plans'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('Navigation to plan editor works', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => PlanViewModel())],
        child: const FitnessApp(),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text('Today\'s Plans'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    expect(find.text('Add / Update Plans'), findsOneWidget);
  });
}
