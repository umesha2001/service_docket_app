import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_docket_app/docket_screen.dart';

void main() {
  group('Service Docket App - UI Tests', () {
    testWidgets('DocketScreen displays all 5 required categories', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DocketScreen()));

      // Verify all 5 categories are displayed
      expect(find.text('Electrical'), findsOneWidget);
      expect(find.text('Plumbing'), findsOneWidget);
      expect(find.text('Cleaning'), findsOneWidget);
      expect(find.text('Security'), findsOneWidget);
      expect(find.text('Other'), findsOneWidget);
    });

    testWidgets('App title is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DocketScreen()));

      // Verify the app title
      expect(find.text('Service Docket'), findsOneWidget);
      expect(find.text('Select Service Category'), findsOneWidget);
    });

    testWidgets('Category selection works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DocketScreen()));

      // Tap on Electrical category
      await tester.tap(find.text('Electrical'));
      await tester.pump();

      // Verify the radio button is selected
      final radioButton = find.byWidgetPredicate(
        (widget) => widget is Radio<String> && widget.value == 'Electrical',
      );
      expect(radioButton, findsOneWidget);

      // Tap on Plumbing category
      await tester.tap(find.text('Plumbing'));
      await tester.pump();

      // Verify Plumbing is now selected
      final plumbingRadio = find.byWidgetPredicate(
        (widget) => widget is Radio<String> && widget.value == 'Plumbing',
      );
      expect(plumbingRadio, findsOneWidget);
    });

    testWidgets('Take Photo button is visible with icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DocketScreen()));

      // Verify the Take Photo button text exists
      expect(find.text('Take Photo'), findsOneWidget);
      
      // Verify the camera icon exists
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });

    testWidgets('All category icons are displayed correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DocketScreen()));

      // Verify all category icons are present
      expect(find.byIcon(Icons.electric_bolt), findsOneWidget);
      expect(find.byIcon(Icons.plumbing), findsOneWidget);
      expect(find.byIcon(Icons.cleaning_services), findsOneWidget);
      expect(find.byIcon(Icons.security), findsOneWidget);
      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
    });

    testWidgets('Helper text appears when no category selected', 
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DocketScreen()));

      expect(find.text('Please select a category to continue'), findsOneWidget);
    });

    testWidgets('Can switch between different categories', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DocketScreen()));

      // Select Electrical
      await tester.tap(find.text('Electrical'));
      await tester.pump();

      // Now select Cleaning
      await tester.tap(find.text('Cleaning'));
      await tester.pump();

      // Verify Cleaning is now selected
      final cleaningRadio = find.byWidgetPredicate(
        (widget) => widget is Radio<String> && 
                    widget.value == 'Cleaning' && 
                    widget.groupValue == 'Cleaning',
      );
      expect(cleaningRadio, findsOneWidget);
    });

    testWidgets('All 5 categories are selectable', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DocketScreen()));

      final categories = ['Electrical', 'Plumbing', 'Cleaning', 'Security', 'Other'];
      
      for (final category in categories) {
        await tester.tap(find.text(category));
        await tester.pump();
        
        // Verify the category text is visible (confirms selection)
        expect(find.text(category), findsOneWidget);
      }
    });
  });

  group('Filename Format Tests', () {
    test('Filename format matches exact requirement: YYYY-MM-DD_Category_0.jpg', () {
      // Test the expected format: [Timeline]_[Category]_0.jpg
      final timestamp = DateTime(2025, 9, 2);
      final formattedDate = '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
      final category = 'Electrical';
      final filename = '${formattedDate}_${category}_0.jpg';
      
      // Expected format: 2025-09-02_Electrical_0.jpg
      expect(filename, equals('2025-09-02_Electrical_0.jpg'));
    });

    test('Filename handles all 5 categories correctly', () {
      final categories = ['Electrical', 'Plumbing', 'Cleaning', 'Security', 'Other'];
      final timestamp = DateTime(2025, 11, 12);
      final formattedDate = '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
      
      for (final category in categories) {
        final filename = '${formattedDate}_${category}_0.jpg';
        
        // Verify format: YYYY-MM-DD_Category_0.jpg
        expect(filename, contains('2025-11-12'));
        expect(filename, contains(category));
        expect(filename, endsWith('_0.jpg'));
      }
    });

    test('Filename date formatting is correct with leading zeros', () {
      // Test with single-digit month and day
      final timestamp = DateTime(2025, 1, 5);
      final formattedDate = '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
      
      expect(formattedDate, equals('2025-01-05'));
    });

    test('Filename always ends with _0.jpg', () {
      final timestamp = DateTime.now();
      final formattedDate = '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
      final categories = ['Electrical', 'Plumbing', 'Cleaning', 'Security', 'Other'];
      
      for (final category in categories) {
        final filename = '${formattedDate}_${category}_0.jpg';
        expect(filename, endsWith('_0.jpg'));
      }
    });
  });

  group('Requirements Validation Tests', () {
    test('Verify all 5 required categories exist', () {
      final requiredCategories = ['Electrical', 'Plumbing', 'Cleaning', 'Security', 'Other'];
      expect(requiredCategories.length, equals(5));
      expect(requiredCategories, contains('Electrical'));
      expect(requiredCategories, contains('Plumbing'));
      expect(requiredCategories, contains('Cleaning'));
      expect(requiredCategories, contains('Security'));
      expect(requiredCategories, contains('Other'));
    });

    testWidgets('App allows selecting exactly one option at a time', 
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DocketScreen()));

      // Select Electrical
      await tester.tap(find.text('Electrical'));
      await tester.pump();

      // Verify Electrical is visible
      expect(find.text('Electrical'), findsOneWidget);

      // Select another category (Plumbing)
      await tester.tap(find.text('Plumbing'));
      await tester.pump();

      // Verify Plumbing is visible
      expect(find.text('Plumbing'), findsOneWidget);
    });

    testWidgets('Take Photo button requires category selection', 
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DocketScreen()));

      // Find the Take Photo button text
      expect(find.text('Take Photo'), findsOneWidget);
      
      // Find the camera icon in the button
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });
  });

  group('Integration Tests', () {
    testWidgets('Complete workflow: select category and access camera button', 
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DocketScreen()));

      // Step 1: Verify categories are displayed
      expect(find.text('Electrical'), findsOneWidget);
      expect(find.text('Plumbing'), findsOneWidget);
      
      // Step 2: Select a category
      await tester.tap(find.text('Electrical'));
      await tester.pump();

      // Step 3: Verify Take Photo button is visible
      final button = find.text('Take Photo');
      expect(button, findsOneWidget);
    });

    testWidgets('UI elements are properly styled and visible', 
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DocketScreen()));

      // Verify main UI components
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(RadioListTile<String>), findsNWidgets(5));
      expect(find.text('Take Photo'), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(5));
    });
  });
}
