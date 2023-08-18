import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/api.dart';
import 'package:pod/model/product.dart';
import 'package:pod/providers/auth_provider.dart';
import 'package:pod/providers/cart_provider.dart';
import 'package:pod/view/more_detail.dart';




class DetailPage extends StatelessWidget{
  final Product product;
  const DetailPage({super.key, required this.product});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.product_name),
      ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Container(
                         height: 270,
                         width: double.infinity,
                         child: Hero(
                             tag:product.id,
                             child: CachedNetworkImage(imageUrl: '${Api.baseUrl}${product.product_image}'))),
                     Container(
                       padding: EdgeInsets.all(20),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(product.product_name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                         SizedBox(height: 20,),
                         Text(product.product_detail, maxLines: 10,style: TextStyle(color: Colors.amberAccent),),
                         Align(
                             alignment: Alignment.centerRight,
                             child: TextButton(onPressed: (){
                               Get.to(() => MoreDetail(product: product,), transition: Transition.leftToRight);
                             }, child: Text('Click here for more')))
                       ],
                     )),

                   ],
                 )),

              Consumer(
                builder: (context, ref, child){
                  final auth = ref.watch(authProvider);

                 return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: ElevatedButton(onPressed: auth.user!.isAdmin ? null: (){
                      ref.read(cartProvider.notifier).addToCart(product, context);
                    }, child: Text('Add To Cart')),
                  );

                },
              )
            ],
          ),
        )
    );
  }
}
