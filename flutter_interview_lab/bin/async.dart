import 'dart:io';

void main() async{
  //Futures -> Promises in js 
  //states -> incomplete and complete
  // fetchpost().then((p){
  //   print(p.title);
  // });
  final post = await fetchpost();
  print(post.userId);
}

Future<Post>fetchpost(){
  const delay = Duration(seconds: 3);
  return Future.delayed(delay,(){
    return Post('myPOST',123);
  });
}


class Post{
  String title;
  int userId;

  Post(this.title,this.userId);
}