// NOTE 09 WORKBOOK. This covers the same ideas in four different tools.
// Check it:  flutter test workbook_test/w09_test.dart
// Answers are in lib/workbook_answers/w09.dart. Try for 5 minutes first.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 1. VALUENOTIFIER. A TextButton showing 'Likes: 0', adding 1 on each tap.
/// Use a ValueNotifier and ValueListenableBuilder, not setState. Dispose it.
class LikeButton extends StatefulWidget {
  const LikeButton({super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 2. CHANGENOTIFIER. Keep a private list. Replace it with a new list on each
/// change, and call notifyListeners.
class CartModel extends ChangeNotifier {
  List<String> get items => throw UnimplementedError();
  int get count => throw UnimplementedError();
  void add(String item) => throw UnimplementedError();

  /// Remove every copy of this item.
  void remove(String item) => throw UnimplementedError();
}

/// 3. PROVIDER, READING. Show 'Cart: <count>', and rebuild when it changes.
/// Which one do you use in build: watch or read?
class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 4. PROVIDER, CALLING. A TextButton saying 'Add <item>' that adds it to the
/// cart. Which do you use in a callback: watch or read?
class AddToCartButton extends StatelessWidget {
  const AddToCartButton({super.key, required this.item});
  final String item;

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 5. RIVERPOD. Starts at 0. add puts on points. reset goes back to 0.
class ScoreNotifier extends Notifier<int> {
  @override
  int build() => throw UnimplementedError();

  void add(int points) => throw UnimplementedError();
  void reset() => throw UnimplementedError();
}

final scoreProvider = NotifierProvider<ScoreNotifier, int>(ScoreNotifier.new);

/// 6. RIVERPOD, WIDGET. Change this to a ConsumerWidget. Show a TextButton
/// saying 'Score: <score>', and each tap adds 10.
class ScoreView extends ConsumerWidget {
  const ScoreView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      throw UnimplementedError();
}

/// 7. CUBIT. Starts false. toggle flips it.
class LightCubit extends Cubit<bool> {
  LightCubit() : super(false);

  void toggle() => throw UnimplementedError();
}

// 8. BLOC. The states and events are finished for you.
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

/// Handle both events inside the constructor using on<...>.
/// LoginPressed: emit LoggingIn, then `await Future<void>.delayed(Duration.zero)`
/// to act like a server call. Then emit LoginFailed('Name is required') if the
/// name is empty, or LoggedIn(name) if it isn't.
/// LogoutPressed: emit LoggedOut.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoggedOut());
}
