import 'package:hive/hive.dart';
part 'cart_item.g.dart';


@HiveType(typeId: 0)
class CartItem extends HiveObject{

  @HiveField(0)
  String name;

  @HiveField(1)
  int qty;

  @HiveField(2)
  String image;

  @HiveField(3)
  int price;

  @HiveField(4)
  String product;

  CartItem({
    required this.product,
    required this.name,
    required this.image,
    required this.price,
    required this.qty
});


}

