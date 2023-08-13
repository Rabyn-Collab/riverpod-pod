import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/api.dart';
import 'package:pod/constants/gap.dart';
import 'package:pod/providers/auth_provider.dart';
import 'package:pod/providers/cart_provider.dart';
import 'package:pod/service/product_service.dart';
import 'package:pod/view/cart_page.dart';
import 'package:pod/view/detail_page.dart';
import 'package:pod/view/product_list.dart';








class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final productData = ref.watch(productProvider);
        final authData = ref.watch(authProvider);
        return Scaffold(
            appBar: AppBar(
              actions: [
               if(!authData.user!.isAdmin) IconButton(onPressed: (){
                  Get.to(() => CartPage());
                }, icon: Icon(Icons.shopping_cart))
              ],
            ),
            drawer: Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        CircleAvatar(
                          radius: 25,
                          child: Text(authData.user!.fullname.substring(0,1).toUpperCase()),
                        ),
                      Sizes.gapH10,
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.mail),
                        title: Text(authData.user!.email),
                      )
                    ],
                  ),
                      )),

                  if(authData.user!.isAdmin) ListTile(
                    onTap: () {
                      Get.back();
                        Get.to(() => ProductList(), transition: Transition.leftToRight);

                    },
                    leading: Icon(Icons.account_balance_wallet, color: Colors.white,),
                    title: Text('Product List'),
                  ),
                  ListTile(
                    onTap: () {
                       ref.read(authProvider.notifier).userLogOut();
                       ref.read(cartProvider.notifier).clearCart();
                    },
                    leading: Icon(Icons.exit_to_app, color: Colors.white,),
                    title: Text('User Log Out'),
                  ),


                ],
              ),
            ),
            body:  Container(
              child:   productData.when(
                  data: (data) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.builder(
                        itemCount: data.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10
                          ),
                          itemBuilder: (context, index){
                            final product = data[index];
                            return InkWell(
                              onTap: (){
                                Get.to(() => DetailPage(product: product));
                              },
                              child: GridTile(
                                  child: Hero(
                                    tag: product.id,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl:  '${Api.baseUrl}${product.product_image}'),
                                  ),
                                footer: Container(
                                  color: Colors.black.withOpacity(0.7),
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text(product.product_name)),
                                      Text('Rs.${product.product_price}')
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                    );
                  },
                  error: (err, stack) => Center(child: Text('$err')),
                  loading: () => Center(child: CircularProgressIndicator())
              ),
            )


        );
      }
    );
  }
}
