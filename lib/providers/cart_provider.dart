import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pod/common_widgets/snack_widget.dart';
import 'package:pod/main.dart';
import 'package:pod/model/cart_item.dart';
import 'package:pod/model/product.dart';




final cartProvider = StateNotifierProvider<CartProvider, List<CartItem>>((ref) => CartProvider(ref.watch(boxA)));

class CartProvider extends StateNotifier<List<CartItem>>{
  CartProvider(super.state);

  void addToCart(Product product, BuildContext context){
    if(state.isEmpty){
      final newCartItem = CartItem(
          product: product.id,
          name: product.product_name,
          image: product.product_image,
          price: product.product_price,
          qty: 1
      );
      Hive.box<CartItem>('carts').add(newCartItem);
      state = [newCartItem];
      CommonSnack.successSnack(context: context,msg:  'Successfully added to cart', isCart: true);
    }else{
      final isThere = state.firstWhereOrNull((element) => element.product == product.id);
      if(isThere == null){
        final newCartItem = CartItem(
            product: product.id,
            name: product.product_name,
            image: product.product_image,
            price: product.product_price,
            qty: 1
        );
        Hive.box<CartItem>('carts').add(newCartItem);
        state = [...state, newCartItem];
        CommonSnack.successSnack(context: context,msg:  'Successfully added to cart', isCart: true);
      }else{
        CommonSnack.successSnack(context: context,msg:  'Already added to cart', isCart: true);
      }

    }

  }


  void singleAdd(){

  }
  void singleRemove(){

  }

  void removeFromCart(){

  }




}