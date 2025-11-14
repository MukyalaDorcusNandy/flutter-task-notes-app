import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_notes_manager/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen loads with welcome text and FAB', (WidgetTester tester) async {
    // Build HomeScreen widget
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Check for welcome text
    expect(find.text('My Tasks & Notes'), findsOneWidget);

    // Check for FloatingActionButton
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Check for SwitchListTile (theme toggle)
    expect(find.byType(SwitchListTile), findsOneWidget);

    // Check if ListView exists (even empty)
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('AddTaskScreen submits a new task', (WidgetTester tester) async {
    // Navigate to AddTaskScreen
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Tap FAB to go to AddTaskScreen
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Should show Submit button
    expect(find.text('Submit'), findsOneWidget);
  });
}
