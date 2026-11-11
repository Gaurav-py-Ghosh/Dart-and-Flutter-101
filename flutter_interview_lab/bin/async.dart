import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
void main() async {
  //Futures -> Promises in js 
  //states -> incomplete and complete
  // fetchpost().then((p){
  //   print(p.title);
  // });

  
//   final post = await fetchpost();
//   print(post.userId);
//
  final post = await fetchpost();
  print(post.userId);
  print(post.title);
}

Future<Post> fetchpost()async{
  var url = Uri.https('jsonplaceholder.typicode.com','/posts/1');
  var response =await http.get(url);
  Map<String,dynamic> json = convert.jsonDecode(response.body);
  
  // print(json.keys);
  return Post(json['title'],json['userId']);
}


class Post{
  String title;
  int userId;

  Post(this.title,this.userId);
}