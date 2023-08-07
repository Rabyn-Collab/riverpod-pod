
import 'package:flutter/material.dart';



class CommonSnack{

  static successSnack ({
   required BuildContext context ,required String msg, bool? isCart}){
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              action: isCart == true ? SnackBarAction(
                  label: 'Go to Cart', onPressed: (){

              }) : null,
              duration: Duration(seconds: 1),backgroundColor: Colors.blueGrey,content: Text(msg, style: TextStyle(color: Colors.white),)));
  }


  static errrorSnack ({
    required BuildContext context ,required String msg, bool? isCart}){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            action: isCart == true ? SnackBarAction(
                label: 'Go to Cart', onPressed: (){

            }) : null,
            duration: Duration(seconds: 1),backgroundColor: Colors.pinkAccent,content: Text(msg, style: TextStyle(color: Colors.white),)));
  }


}