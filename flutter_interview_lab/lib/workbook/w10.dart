// NOTE 10 WORKBOOK.
// Check it:  flutter test workbook_test/w10_test.dart
// Answers are in lib/workbook_answers/w10.dart. Try for 5 minutes first.
//
// You'll need these imports for some answers:
//   import 'dart:convert';    (jsonDecode)
//   import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// 1. fromJson reads id, title and likes. If likes is missing, use 0.
/// toJson does the opposite.
class Post {
  const Post({required this.id, required this.title, this.likes = 0});

  factory Post.fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();

  final int id;
  final String title;
  final int likes;

  Map<String, dynamic> toJson() => throw UnimplementedError();
}

/// 2. Turn a JSON text like '[{"id":1,"title":"A"}]' into a List<Post>.
List<Post> parsePosts(String body) => throw UnimplementedError();

/// 3. GET https://example.test/posts using the client that's passed in.
/// If the status isn't 200, throw an Exception. Otherwise return parsePosts.
Future<List<Post>> fetchPosts(http.Client client) => throw UnimplementedError();

/// 4. Use FutureBuilder for all four states:
/// loading: CircularProgressIndicator. Error: Text('Something went wrong').
/// Empty: Text('No posts'). Data: ListView.builder with a Text for each title.
class PostsView extends StatelessWidget {
  const PostsView({super.key, required this.posts});
  final Future<List<Post>> posts;

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 5. Use StreamBuilder. Before any value arrives, show Text('Waiting').
/// After that, show Text('Now: <value>').
class LiveCounter extends StatelessWidget {
  const LiveCounter({super.key, required this.numbers});
  final Stream<int> numbers;

  @override
  Widget build(BuildContext context) => throw UnimplementedError();
}

/// 6. Save the name in shared_preferences, under the key 'name'.
Future<void> saveName(String name) => throw UnimplementedError();

/// 7. Load the saved name. If there's none, return 'Guest'.
Future<String> loadName() => throw UnimplementedError();
