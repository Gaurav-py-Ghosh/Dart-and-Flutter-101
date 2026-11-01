// NOTE 06 WORKBOOK. Replace each placeholder with your own widgets.
// Check it:  flutter test workbook_test/w06_test.dart
// Answers are in lib/workbook_answers/w06.dart. Try for 5 minutes first.

import 'package:flutter/material.dart';

/// 1. A Card with a Row inside, holding two things:
/// a CircleAvatar, then a Column with the name and the role as Text widgets.
class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.name, required this.role});
  final String name;
  final String role;

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 2. A Row with the label on the far left, and 'Rs <price>' on the far right.
/// Use Expanded to push them apart. A long label must not overflow.
class PriceRow extends StatelessWidget {
  const PriceRow({super.key, required this.label, required this.price});
  final String label;
  final int price;

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 3. A lazy list: use ListView.builder, with a ListTile for each name.
class NameList extends StatelessWidget {
  const NameList({super.key, required this.names});
  final List<String> names;

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 4. A Stack: an Icon(Icons.shopping_cart), with the count in a Positioned
/// Text on top. Show the count only if it's above 0.
class BadgeIcon extends StatelessWidget {
  const BadgeIcon({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 5. Show Text('Wide') if there's more than 600 available, or else
/// Text('Narrow'). Use LayoutBuilder.
class ResponsiveLabel extends StatelessWidget {
  const ResponsiveLabel({super.key});

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 6. A Column holding a scrolling list of messages (ListView.builder with
/// a Text for each), and a TextField at the bottom. This crashes unless you
/// use the fix from the note.
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.messages});
  final List<String> messages;

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}
