import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/common_widgets/snack_widget.dart';
import 'package:pod/model/cart_item.dart';
import 'package:pod/providers/auth_provider.dart';
import 'package:pod/providers/order_provider.dart';
import 'package:pod/view/home_page.dart';




class PlaceOrder extends ConsumerWidget{
  final List<CartItem> carts;
  final int total;
  const PlaceOrder({super.key, required this.carts, required this.total});

  @override
  Widget build(BuildContext context, ref) {
    ref.listen(orderProvider, (previous, next) {
      if(next.isError){
        CommonSnack.errrorSnack(context: context,msg:  next.errText);
      }else if(next.isSuccess){
        Get.offAll(() => HomePage());
        CommonSnack.successSnack(context: context,msg:  'successfully place Order');
      }
    });
    final authData = ref.watch(authProvider);
    final order = ref.watch(orderProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail'),
      ),
        body: SafeArea(
            child:Padding(
              padding: const EdgeInsets.only(top: 100, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Delivery Address:')),
                      Expanded(
                          flex: 2,
                          child: Text(' ${authData.user!.shipping.address}, ${authData.user!.shipping.city}'))
                    ],
                  ),
                  SizedBox(height: 20,),
                  Table(
                    border: TableBorder.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 2),
                    children: [

                      TableRow( children: [
                        Column(children:[Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('Products', style: TextStyle(fontSize: 17.0)),
                        )]),
                        Column(children:[Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('Qty', style: TextStyle(fontSize: 17.0)),
                        )]),
                        Column(children:[Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('Price', style: TextStyle(fontSize: 17.0)),
                        )]),

                      ]),

                      TableRow(
                          children: [
                        Column(children:carts.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(e.name),
                        )).toList()),
                        Column(children:carts.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('x  ${e.qty}'),
                        )).toList()),
                        Column(children:carts.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('Rs. ${e.price}'),
                        )).toList()),
                      ]),

                    ],
                  ),
               Padding(
                 padding: const EdgeInsets.only(top: 20, bottom: 50),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text('Total Amount'),
                     Padding(
                       padding: const EdgeInsets.only(right: 25),
                       child: Text('Rs. $total'),
                     )
                   ],
                 ),
               ),
                  ElevatedButton(onPressed: order.isLoad ? null : (){
                    ref.read(orderProvider.notifier).addOrder(orderItems: carts, totalPrice: total, token: authData.user!.token);
                  }, child: order.isLoad ? Center(child: CircularProgressIndicator()): Text('Place An Order'))
                ],
              ),
            )
        )
    );
  }
}
