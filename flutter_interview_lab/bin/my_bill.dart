double splitbill({required double totalamount, required int amountofpeople, double tip = 0}){
  return((totalamount+tip)/amountofpeople);
}


String describeBill(double share, [double commute = 0]){
  if(share+commute>=500){
    return("Expensive");
  }else if(share+commute>=200){
    return("Adequate");
  }
  return("Cheap");

}






void main() {
  void typesDemo() {
  dynamic anything = 'hello';
  print(anything.length);
  anything = 42;
  print(anything.isEven);
  try {
    print(anything.length);
  } on NoSuchMethodError {
    print('dynamic crashed at runtime: an int has no length');
  }

  Object? box = 'hello';
  if (box is String) {
    print(box.length);
  }
  box = 42;
  print(box is String);
  print(box.runtimeType);
}
  typesDemo();
  const people = ['Asha', 'Ravi', 'Meera']; 
  final prices = {'Pizza': 600.0, 'Tea': 90.0, 'Cake': 310.0};

  var total = 0.0;
  for (final entry in prices.entries) {
    print('${entry.key}: ${entry.value}');
    total += entry.value;
  }
  print('Total: $total');
  if(total>800){
    total=total*0.90;
  }
  print("Since it above 800 spend cap discounted total:$total");
  final share = splitbill(totalamount: total, amountofpeople: people.length, tip: 20);
  print('Each Pays: ${share.toStringAsFixed(2)}, Which is ${describeBill(share,20.00)}');
  // print(describeBill(share,20.00));
  for( var n in people){
    print("$n : ${share.toStringAsFixed(2)}");
  }
  // final costly = prices.entries
  // .where((n)=>n.value > 100).map((n)=>n.key).toList();
  final costly = <String>[];
  for (var n in prices.entries){
    if(n.value > 100){
      costly.add(n.key);
    }
  }
  
  print("Costly Items = $costly");

  String? coupon;
  print('Cupon:${coupon??'none'}, length ${coupon?.length ?? 0}');
  coupon = 'SAVE10';
  print('Coupon:$coupon , Length:${coupon.length}');

}