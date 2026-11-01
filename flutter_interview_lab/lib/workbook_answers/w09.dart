// ANSWERS for note 09. Try lib/workbook/w09.dart first.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  final _likes = ValueNotifier<int>(0);

  @override
  void dispose() {
    _likes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _likes,
      builder: (context, likes, _) => TextButton(
        onPressed: () => _likes.value++,
        child: Text('Likes: $likes'),
      ),
    );
  }
}

class CartModel extends ChangeNotifier {
  List<String> _items = const [];

  List<String> get items => _items;
  int get count => _items.length;

  void add(String item) {
    _items = [..._items, item];
    notifyListeners();
  }

  void remove(String item) {
    _items = [
      for (final existing in _items)
        if (existing != item) existing,
    ];
    notifyListeners();
  }
}

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.watch<CartModel>().count;
    return Text('Cart: $count');
  }
}

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({super.key, required this.item});
  final String item;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.read<CartModel>().add(item),
      child: Text('Add $item'),
    );
  }
}

class ScoreNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void add(int points) => state = state + points;
  void reset() => state = 0;
}

final scoreProvider = NotifierProvider<ScoreNotifier, int>(ScoreNotifier.new);

class ScoreView extends ConsumerWidget {
  const ScoreView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => ref.read(scoreProvider.notifier).add(10),
      child: Text('Score: ${ref.watch(scoreProvider)}'),
    );
  }
}

class LightCubit extends Cubit<bool> {
  LightCubit() : super(false);

  void toggle() => emit(!state);
}

sealed class LoginState {
  const LoginState();
}

class LoggedOut extends LoginState {
  const LoggedOut();
}

class LoggingIn extends LoginState {
  const LoggingIn();
}

class LoggedIn extends LoginState {
  const LoggedIn(this.name);
  final String name;
}

class LoginFailed extends LoginState {
  const LoginFailed(this.message);
  final String message;
}

sealed class LoginEvent {
  const LoginEvent();
}

class LoginPressed extends LoginEvent {
  const LoginPressed(this.name);
  final String name;
}

class LogoutPressed extends LoginEvent {
  const LogoutPressed();
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoggedOut()) {
    on<LoginPressed>((event, emit) async {
      emit(const LoggingIn());
      await Future<void>.delayed(Duration.zero);
      if (event.name.isEmpty) {
        emit(const LoginFailed('Name is required'));
      } else {
        emit(LoggedIn(event.name));
      }
    });
    on<LogoutPressed>((event, emit) => emit(const LoggedOut()));
  }
}
