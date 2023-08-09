import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/api.dart';
import 'package:pod/providers/cart_provider.dart';


class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer(
            builder: (context, ref, child) {
              final cartData = ref.watch(cartProvider);
              final totalAmount = ref.watch(cartProvider.notifier).totalAmount;
              return cartData.isEmpty ? Center(child: Text('Add Some Product to Cart')): Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                       itemCount: cartData.length,
                      itemBuilder: (context, index){
                         return Row(
                           children: [
                           CachedNetworkImage(
                               height: 200,
                               width: 200,
                               imageUrl: '${Api.baseUrl}${cartData[index].image}'),
                             SizedBox(width: 19,),
                             Expanded(
                               child: Padding(
                                 padding: const EdgeInsets.only(right: 10),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   crossAxisAlignment: CrossAxisAlignment.end,
                                   children: [
                                     IconButton(onPressed: (){
                                       ref.read(cartProvider.notifier).removeFromCart(cartData[index]);
                                     }, icon: Icon(Icons.close)),
                                     SizedBox(height: 20,),
                                     Text(cartData[index].name),
                                     SizedBox(height: 10,),
                                     Text('Rs.${cartData[index].price} X ${cartData[index].qty}'),
                                     SizedBox(height: 10,),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.end,
                                       children: [
                                         OutlinedButton(onPressed: (){
                                           ref.read(cartProvider.notifier).singleAdd(cartData[index]);
                                         }, child: Icon(Icons.add)),
                                         Padding(
                                           padding: const EdgeInsets.symmetric(horizontal: 10),
                                           child: Text('${cartData[index].qty}'),
                                         ),
                                         OutlinedButton(onPressed: (){
                                           ref.read(cartProvider.notifier).singleRemove(cartData[index]);
                                         }, child: Icon(Icons.remove)),
                                       ],
                                     )
                                   ],
                                 ),
                               ),
                             )
                           ],
                         );
                      }
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total:-'),
                            Text('Rs. $totalAmount')
                          ],
                        ),
                        SizedBox(height: 10,),
                        ElevatedButton(onPressed: (){}, child: Text('Check Out'))
                      ],
                    ),
                  )
                ],
              );
            }
             )
    );
  }
}
