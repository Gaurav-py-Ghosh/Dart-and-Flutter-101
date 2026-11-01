import 'package:flutter/material.dart';
import 'package:flutter_interview_lab/workbook_answers/w09.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart' as p;

Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('1 LikeButton', (tester) async {
    await tester.pumpWidget(wrap(const LikeButton()));
    expect(find.byType(ValueListenableBuilder<int>), findsOneWidget);
    await tester.tap(find.byType(TextButton));
    await tester.pump();
    expect(find.text('Likes: 1'), findsOneWidget);
  });

  test('2 CartModel notifies, and makes a new list', () {
    final cart = CartModel();
    var notified = 0;
    cart.addListener(() => notified++);
    final before = cart.items;
    cart.add('Tea');
    cart.add('Milk');
    cart.add('Tea');
    expect(cart.count, 3);
    expect(notified, 3);
    expect(identical(before, cart.items), isFalse);
    cart.remove('Tea');
    expect(cart.items, ['Milk']);
    expect(notified, 4);
  });

  testWidgets('3 and 4 Provider updates the badge', (tester) async {
    await tester.pumpWidget(
      p.ChangeNotifierProvider(
        create: (_) => CartModel(),
        child: wrap(
          const Column(
            children: [CartBadge(), AddToCartButton(item: 'Tea')],
          ),
        ),
      ),
    );
    expect(find.text('Cart: 0'), findsOneWidget);
    await tester.tap(find.text('Add Tea'));
    await tester.pump();
    expect(find.text('Cart: 1'), findsOneWidget);
  });

  test('5 ScoreNotifier', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(scoreProvider), 0);
    container.read(scoreProvider.notifier).add(5);
    expect(container.read(scoreProvider), 5);
    container.read(scoreProvider.notifier).reset();
    expect(container.read(scoreProvider), 0);
  });

  testWidgets('6 ScoreView', (tester) async {
    await tester.pumpWidget(ProviderScope(child: wrap(const ScoreView())));
    expect(find.text('Score: 0'), findsOneWidget);
    await tester.tap(find.byType(TextButton));
    await tester.pump();
    expect(find.text('Score: 10'), findsOneWidget);
  });

  test('7 LightCubit', () async {
    final cubit = LightCubit();
    expect(cubit.state, isFalse);
    cubit.toggle();
    expect(cubit.state, isTrue);
    cubit.toggle();
    expect(cubit.state, isFalse);
    await cubit.close();
  });

  test('8 LoginBloc', () async {
    final bloc = LoginBloc();
    final seen = <LoginState>[];
    final subscription = bloc.stream.listen(seen.add);

    bloc.add(const LoginPressed('Asha'));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(seen.first, isA<LoggingIn>());
    expect((seen.last as LoggedIn).name, 'Asha');

    bloc.add(const LoginPressed(''));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect((seen.last as LoginFailed).message, 'Name is required');

    bloc.add(const LogoutPressed());
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(seen.last, isA<LoggedOut>());

    await subscription.cancel();
    await bloc.close();
  });
}
