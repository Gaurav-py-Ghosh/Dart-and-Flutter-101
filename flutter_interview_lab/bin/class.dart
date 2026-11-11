class MenuItem{
  String? title;
  double? price;
  MenuItem(this.title,this.price);
  String formatString()=>"$title ---> $price";

  @override
  String toString() => formatString();
}
  

  


class PizzaItem extends MenuItem{
  List<String> Toppings;
  // PizzaItem(String name , double price, this.Toppings):super(name,price);
  PizzaItem(super.title, super.price, this.Toppings);
  
  @override
  String formatString(){
    var formatedToppings = "Contains: ";
    for (final tops in Toppings){
      formatedToppings = '$formatedToppings $tops';
    }


    return "$title ---> $price \n $formatedToppings";
  }
    @override
    String toString() => 'Instance of Pizza: Name: $title, Price: $price';

}


class Collection<T>{
  String name;
  List<T> data;
  Collection(this.name, this.data);

  T randomItem(){
    data.shuffle();
    return data[0];
  }
}




void main(){

  var noodles = MenuItem('Veg Noodles',99.99);
  var pizza = PizzaItem('Dominos pizza',12.99,["Mushroom","Peparonis"]);
  // print(noodles.formatString());
  // print(pizza.formatString());
  print(noodles);
  print(pizza);
  var foods = Collection<MenuItem>('Menu Items', [noodles,pizza]);
  var random = foods.randomItem();
  print(random);
}