import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/api.dart';
import 'package:pod/common_widgets/snack_widget.dart';
import 'package:pod/constants/colors.dart';
import 'package:pod/constants/gap.dart';
import 'package:pod/model/product.dart';
import 'package:pod/providers/auth_provider.dart';
import 'package:pod/providers/mode.dart';
import 'package:pod/providers/product_provider.dart';
import 'package:pod/service/product_service.dart';


final items = [
  'Nike',
  'Addidas',
  'Sunsilk',
  'Smiley',
  'Levis',
];


final items1 = [
  'Sports',
  'Beauty',
  'Fashion',
  'Tech',
  'Food',
];

class UpdatePage extends ConsumerStatefulWidget {

  final Product product;
  UpdatePage(this.product);

  @override
  ConsumerState<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends ConsumerState<UpdatePage> {


  TextEditingController detailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  final _form = GlobalKey<FormState>();


  String brand = items[0];
  String category = items1[0];

  @override
  void initState() {
    detailController..text  = widget.product.product_detail;
        nameController..text = widget.product.product_name;
    priceController..text = widget.product.product_price.toString();
    stockController..text = widget.product.countInStock.toString();
    brand = widget.product.brand;
    category = widget.product.category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(crudProvider, (previous, next) {
      if(next.isError){
        CommonSnack.errrorSnack(context: context,msg:  next.errText);
      }else if(next.isSuccess){
        ref.invalidate(productProvider);
        CommonSnack.successSnack(context: context,msg:  'successfully register');
        Get.back();
      }
    });
    final crud = ref.watch(crudProvider);
    final image = ref.watch(imageProvider);
    final auth = ref.watch(authProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Consumer(
              builder: (context, ref, child) {
                final mode = ref.watch(modeProvider);
                return Form(
                  autovalidateMode: mode,
                  key: _form,
                  child: ListView(

                    children: [
                      const SizedBox(height: 10,),
                      TextFormField(
                        controller: nameController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colours.whiteColor),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'please provide fullname';
                          } else if (val.length < 5) {
                            return 'must be greater than 5';
                          } else if (val.length > 30) {
                            return 'must be less than 30';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'product_name',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            prefixIcon: Icon(Icons.lock),
                            errorStyle: TextStyle(color: Colors.amber)
                        ),
                      ),
                      Sizes.gapH16,
                      TextFormField(
                        style: TextStyle(color: Colours.whiteColor),
                        controller: detailController,
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'please provide detail';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'product_detail',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            prefixIcon: Icon(Icons.details),
                            errorStyle: TextStyle(color: Colors.amber)
                        ),
                      ),
                      Sizes.gapH16,
                      TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colours.whiteColor),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'please provide price';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'product_price',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            prefixIcon: Icon(Icons.monetization_on),
                            errorStyle: TextStyle(color: Colors.amber)
                        ),
                      ),
                      Sizes.gapH16,
                      TextFormField(
                        controller: stockController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colours.whiteColor),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'please provide stockCount';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'stock',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            prefixIcon: Icon(Icons.map),
                            errorStyle: TextStyle(color: Colors.amber)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: DropdownButton(
                          icon: const Icon(Icons.keyboard_arrow_down),
                          value: brand,
                          isExpanded: true,
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (o){
                            setState(() {
                              brand = o as String;
                            });
                          },

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: DropdownButton(
                          icon: const Icon(Icons.keyboard_arrow_down),
                          value: category,
                          isExpanded: true,
                          items: items1.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (o){
                            setState(() {
                              category = o as String;
                            });
                          },

                        ),
                      ),
                      Sizes.gapH20,
                      InkWell(
                        onTap: (){
                          Get.defaultDialog(
                              title: 'please select an option',
                              actions: [
                                TextButton(onPressed: (){
                                  Get.back();
                                  ref.read(imageProvider.notifier).pickAnImage(false);
                                }, child: Text('Gallery')),
                                TextButton(onPressed: (){
                                  Get.back();
                                  ref.read(imageProvider.notifier).pickAnImage(true);
                                }, child: Text('Camera')),
                              ]
                          );
                        },
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white)
                          ),
                          child: image == null ? Center(child: Image.network('${Api.baseUrl}${widget.product.product_image}')): Image.file(File(image.path)),

                        ),
                      ),
                      Sizes.gapH20,
                      ElevatedButton(
                          onPressed:crud.isLoad ? null: () {
                            FocusScope.of(context).unfocus();
                            _form.currentState!.save();
                            if (_form.currentState!.validate()) {
                              if(image == null){
                                 ref.read(crudProvider.notifier).updateProduct(
                                     product_name: nameController.text.trim(),
                                     product_detail: detailController.text.trim(),
                                     product_price: int.parse(priceController.text.trim()),
                                     brand: brand,
                                     category: category,
                                     countInStock: int.parse(stockController.text.trim()),
                                     token: auth.user!.token,
                                     productId: widget.product.id
                                 );
                              }else{
                                ref.read(crudProvider.notifier).updateProduct(
                                    product_name: nameController.text.trim(),
                                    product_detail: detailController.text.trim(),
                                    product_price: int.parse(priceController.text.trim()),
                                    product_image: image,
                                    brand: brand,
                                    category: category,
                                    countInStock: int.parse(stockController.text.trim()),
                                    token: auth.user!.token,
                                    productId: widget.product.id,
                                  oldImage: widget.product.product_image,
                                );
                              }

                            } else {
                              ref.read(modeProvider.notifier).changeMode();

                            }
                          }, child:  crud.isLoad ? Center(child: CircularProgressIndicator()) :Text('Submit')
                      ),

                    ],
                  ),
                );
              }
          ),
        )
    );
  }
}
