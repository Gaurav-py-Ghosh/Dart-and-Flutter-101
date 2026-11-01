import 'package:flutter/material.dart';
import 'package:flutter_interview_lab/workbook/w06.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('1 ProfileCard', (tester) async {
    await tester.pumpWidget(wrap(const ProfileCard(name: 'Asha', role: 'Dev')));
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('Asha'), findsOneWidget);
    expect(find.text('Dev'), findsOneWidget);
    final avatar = tester.getCenter(find.byType(CircleAvatar));
    expect(avatar.dx, lessThan(tester.getCenter(find.text('Asha')).dx));
  });

  testWidgets('2 PriceRow pushes apart, and long labels fit', (tester) async {
    await tester.pumpWidget(wrap(const PriceRow(label: 'Tea', price: 20)));
    expect(find.text('Rs 20'), findsOneWidget);
    expect(find.byType(Expanded), findsOneWidget);
    final screenWidth = tester.getSize(find.byType(Scaffold)).width;
    expect(tester.getTopRight(find.text('Rs 20')).dx, screenWidth);
    await tester.pumpWidget(wrap(PriceRow(label: 'Long ' * 100, price: 20)));
    expect(tester.takeException(), isNull);
  });

  testWidgets('3 NameList is lazy', (tester) async {
    final names = List.generate(1000, (i) => 'Name $i');
    await tester.pumpWidget(wrap(NameList(names: names)));
    expect(find.text('Name 0'), findsOneWidget);
    expect(find.text('Name 999'), findsNothing);
    expect(find.byType(ListTile).evaluate().length, lessThan(100));
  });

  testWidgets('4 BadgeIcon', (tester) async {
    await tester.pumpWidget(wrap(const BadgeIcon(count: 3)));
    expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    expect(find.byType(Positioned), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    await tester.pumpWidget(wrap(const BadgeIcon(count: 0)));
    expect(find.text('0'), findsNothing);
  });

  testWidgets('5 ResponsiveLabel', (tester) async {
    await tester.pumpWidget(
      wrap(
        const Center(child: SizedBox(width: 700, child: ResponsiveLabel())),
      ),
    );
    expect(find.text('Wide'), findsOneWidget);
    await tester.pumpWidget(
      wrap(
        const Center(child: SizedBox(width: 300, child: ResponsiveLabel())),
      ),
    );
    expect(find.text('Narrow'), findsOneWidget);
  });

  testWidgets('6 ChatScreen does not crash', (tester) async {
    await tester.pumpWidget(wrap(const ChatScreen(messages: ['Hi', 'Hello'])));
    expect(tester.takeException(), isNull);
    expect(find.text('Hi'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
