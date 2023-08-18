import 'package:pod/model/cart_item.dart';



class Orders{

final List<CartItem> orderItems;
final int totalPrice;
final String createdAt;

Orders({
  required this.orderItems,
  required this.totalPrice,
  required this.createdAt
});

   factory Orders.fromJson(Map<String, dynamic> json){
     return Orders(
     orderItems: (json['orderItems'] as List).map((e) => CartItem.fromJson(e)).toList(),
     totalPrice: json['totalPrice'],
       createdAt: json['createdAt']
);
   }


}