import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:searchable_dropdown_widget/searchable_dropdown.dart';

// Test model implementing Searchable
class TestItem implements Searchable {
  final String name;
  final int id;

  TestItem({required this.name, required this.id});

  @override
  String get text => name;

  @override
  String get comparableText => name.toLowerCase();
}

void main() {
  group('Searchable Interface Tests', () {
    test('TestItem implements Searchable correctly', () {
      final item = TestItem(name: 'Test Item', id: 1);
      
      expect(item.text, 'Test Item');
      expect(item.comparableText, 'test item');
    });

    test('Searchable items can be compared', () {
      final item1 = TestItem(name: 'Apple', id: 1);
      final item2 = TestItem(name: 'Banana', id: 2);
      
      expect(item1.comparableText, 'apple');
      expect(item2.comparableText, 'banana');
      expect(item1.comparableText.contains('app'), isTrue);
      expect(item2.comparableText.contains('app'), isFalse);
    });
  });

  group('SearchableDropdown Widget Tests', () {
    testWidgets('SearchableDropdown can be instantiated', (WidgetTester tester) async {
      final controller = TextEditingController();
      final items = [
        TestItem(name: 'Item 1', id: 1),
        TestItem(name: 'Item 2', id: 2),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchableDropdown<TestItem>(
              items: items,
              textController: controller,
              itemBuilder: (item) => ListTile(title: Text(item.name)),
            ),
          ),
        ),
      );

      expect(find.byType(SearchableDropdown), findsOneWidget);
      
      controller.dispose();
    });
  });

  group('SearchableTextFormField Widget Tests', () {
    testWidgets('SearchableTextFormField can be instantiated', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchableTextFormField<TestItem>(
              controller: controller,
              itemBuilder: (item) => ListTile(title: Text(item.name)),
            ),
          ),
        ),
      );

      expect(find.byType(SearchableTextFormField), findsOneWidget);
      
      controller.dispose();
    });
  });
}
