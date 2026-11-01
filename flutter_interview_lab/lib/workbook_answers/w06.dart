// ANSWERS for note 06. Try lib/workbook/w06.dart first.

import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.name, required this.role});
  final String name;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(child: Icon(Icons.person)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(name), Text(role)],
            ),
          ],
        ),
      ),
    );
  }
}

class PriceRow extends StatelessWidget {
  const PriceRow({super.key, required this.label, required this.price});
  final String label;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Text('Rs $price'),
      ],
    );
  }
}

class NameList extends StatelessWidget {
  const NameList({super.key, required this.names});
  final List<String> names;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: names.length,
      itemBuilder: (context, index) => ListTile(title: Text(names[index])),
    );
  }
}

class BadgeIcon extends StatelessWidget {
  const BadgeIcon({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        children: [
          const Icon(Icons.shopping_cart),
          if (count > 0) Positioned(right: 0, top: 0, child: Text('$count')),
        ],
      ),
    );
  }
}

class ResponsiveLabel extends StatelessWidget {
  const ResponsiveLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          Text(constraints.maxWidth > 600 ? 'Wide' : 'Narrow'),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.messages});
  final List<String> messages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) => Text(messages[index]),
          ),
        ),
        const TextField(),
      ],
    );
  }
}
