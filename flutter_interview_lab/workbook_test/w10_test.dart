import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_interview_lab/workbook/w10.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  test('1 Post JSON', () {
    final post = Post.fromJson({'id': 1, 'title': 'A', 'likes': 5});
    expect(post.likes, 5);
    expect(Post.fromJson({'id': 1, 'title': 'A'}).likes, 0);
    expect(post.toJson(), {'id': 1, 'title': 'A', 'likes': 5});
  });

  test('2 parsePosts', () {
    final posts = parsePosts('[{"id":1,"title":"A"},{"id":2,"title":"B"}]');
    expect(posts, isA<List<Post>>());
    expect(posts.last.title, 'B');
  });

  test('3 fetchPosts', () async {
    final good = MockClient(
      (request) async => http.Response('[{"id":1,"title":"A"}]', 200),
    );
    expect((await fetchPosts(good)).single.title, 'A');

    final bad = MockClient((request) async => http.Response('Oops', 500));
    await expectLater(fetchPosts(bad), throwsException);
  });

  testWidgets('4 PostsView has all four states', (tester) async {
    final slow = Completer<List<Post>>();
    await tester.pumpWidget(wrap(PostsView(posts: slow.future)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    slow.complete(const [Post(id: 1, title: 'Hello')]);
    await tester.pump();
    expect(find.text('Hello'), findsOneWidget);

    await tester.pumpWidget(wrap(PostsView(posts: Future.value(const []))));
    await tester.pump();
    expect(find.text('No posts'), findsOneWidget);

    final failing = Completer<List<Post>>();
    await tester.pumpWidget(wrap(PostsView(posts: failing.future)));
    failing.completeError(Exception('down'));
    await tester.pump();
    expect(find.text('Something went wrong'), findsOneWidget);
  });

  testWidgets('5 LiveCounter', (tester) async {
    final controller = StreamController<int>();
    // Not awaited: closing with no listener would otherwise wait forever.
    addTearDown(() => unawaited(controller.close()));
    await tester.pumpWidget(wrap(LiveCounter(numbers: controller.stream)));
    expect(find.text('Waiting'), findsOneWidget);
    controller.add(7);
    await tester.pump();
    expect(find.text('Now: 7'), findsOneWidget);
  });

  test('6 and 7 saveName and loadName', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await loadName(), 'Guest');
    await saveName('Asha');
    expect(await loadName(), 'Asha');
  });
}
