
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pod/view/cart_page.dart';



class CommonSnack{

  static successSnack ({
   required BuildContext context ,required String msg, bool? isCart}){
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              action: isCart == true ? SnackBarAction(
                backgroundColor: Colors.white,
                  textColor: Colors.black,
                  label: 'Go to Cart', onPressed: (){
                Get.to(() => CartPage());
              }) : null,
              duration: Duration(seconds: 1),backgroundColor: Colors.blueGrey,content: Text(msg, style: TextStyle(color: Colors.white),)));
  }


  static errrorSnack ({
    required BuildContext context ,required String msg, bool? isCart}){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            action: isCart == true ? SnackBarAction(
                backgroundColor: Colors.white,
                textColor: Colors.black,
                label: 'Go to Cart', onPressed: (){
              Get.to(() => CartPage());

            }) : null,
            duration: Duration(seconds: 1),backgroundColor: Colors.pinkAccent,content: Text(msg, style: TextStyle(color: Colors.white),)));
  }


}