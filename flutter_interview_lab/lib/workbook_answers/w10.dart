// ANSWERS for note 10. Try lib/workbook/w10.dart first.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Post {
  const Post({required this.id, required this.title, this.likes = 0});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['id'] as int,
    title: json['title'] as String,
    likes: json['likes'] as int? ?? 0,
  );

  final int id;
  final String title;
  final int likes;

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'likes': likes};
}

List<Post> parsePosts(String body) {
  final list = jsonDecode(body) as List<dynamic>;
  return list
      .map((item) => Post.fromJson(item as Map<String, dynamic>))
      .toList();
}

Future<List<Post>> fetchPosts(http.Client client) async {
  final response = await client.get(Uri.parse('https://example.test/posts'));
  if (response.statusCode != 200) {
    throw Exception('Server replied ${response.statusCode}');
  }
  return parsePosts(response.body);
}

class PostsView extends StatelessWidget {
  const PostsView({super.key, required this.posts});
  final Future<List<Post>> posts;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: posts,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) return const Text('Something went wrong');
        final items = snapshot.data!;
        if (items.isEmpty) return const Text('No posts');
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => Text(items[index].title),
        );
      },
    );
  }
}

class LiveCounter extends StatelessWidget {
  const LiveCounter({super.key, required this.numbers});
  final Stream<int> numbers;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: numbers,
      builder: (context, snapshot) =>
          Text(snapshot.hasData ? 'Now: ${snapshot.data}' : 'Waiting'),
    );
  }
}

Future<void> saveName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('name', name);
}

Future<String> loadName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('name') ?? 'Guest';
}
