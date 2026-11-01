// NOTE 12: this code is FINISHED and it works. Don't change it.
// Your job is to write its tests in workbook_test/w12_test.dart.

import 'package:flutter/material.dart';

class ShoppingList extends ChangeNotifier {
  final List<String> _items = [];

  List<String> get items => List.unmodifiable(_items);

  void add(String item) {
    final clean = item.trim();
    if (clean.isEmpty || _items.contains(clean)) return;
    _items.add(clean);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

abstract class PriceApi {
  Future<int> priceOf(String item);
}

class Checkout {
  Checkout(this._api);
  final PriceApi _api;

  Future<int> total(List<String> items) async {
    var sum = 0;
    for (final item in items) {
      sum += await _api.priceOf(item);
    }
    return sum;
  }
}

class GreetingScreen extends StatefulWidget {
  const GreetingScreen({super.key});

  @override
  State<GreetingScreen> createState() => _GreetingScreenState();
}

class _GreetingScreenState extends State<GreetingScreen> {
  String _message = 'Enter your name';
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_message),
        TextField(controller: _controller),
        TextButton(
          onPressed: () =>
              setState(() => _message = 'Hello ${_controller.text}'),
          child: const Text('Greet'),
        ),
      ],
    );
  }
}
