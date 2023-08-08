import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/api.dart';
import 'package:pod/providers/auth_provider.dart';
import 'package:pod/providers/cart_provider.dart';
import 'package:pod/service/product_service.dart';
import 'package:pod/view/cart_page.dart';
import 'package:pod/view/detail_page.dart';








class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final productData = ref.watch(productProvider);
        return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(onPressed: (){
                  Get.to(() => CartPage());
                }, icon: Icon(Icons.shopping_cart))
              ],
            ),
            drawer: Drawer(
              child: ListView(
                children: [
                  ListTile(
                    onTap: () {
                       ref.read(authProvider.notifier).userLogOut();
                    },
                    leading: Icon(Icons.exit_to_app, color: Colors.white,),
                    title: Text('User Log Out'),
                  )
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
