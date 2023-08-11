import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/api.dart';
import 'package:pod/service/product_service.dart';
import 'package:pod/view/admin_crud/add_form.dart';



class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(

              onPressed: (){
                Get.to(() => AddPage(), transition: Transition.leftToRight);
              }, child: Text('Add Product', style: TextStyle(color: Colors.pink),))
        ],
      ),
        body: Consumer(
            builder: (context, ref, child) {
              final productData = ref.watch(productProvider);
              return SafeArea(
                child: Container(
                    child: productData.when(
                        data: (data){
                          return ListView.separated(
                            separatorBuilder: (c, i) => Divider(
                              color: Colors.white.withOpacity(0.5),
                              height: 20,
                            ),
                              itemCount: data.length,
                              itemBuilder: (context, index){
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Image.network('${Api.baseUrl}${data[index].product_image}'),
                                  title: Text(data[index].product_name),
                                  trailing: Container(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
                                        IconButton(onPressed: (){}, icon: Icon(Icons.delete)),

                                      ],
                                    ),
                                  ),
                                );
                              }
                          );
                        },
                        error: (err, stack) => Center(child: Text('$err')),
                        loading: () => Center(child: CircularProgressIndicator())
                    )
                ),
              );
            }
    )
    );
  }
}
