import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/common_widgets/snack_widget.dart';
import 'package:pod/constants/colors.dart';
import 'package:pod/constants/gap.dart';
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

class AddPage extends ConsumerStatefulWidget {


  @override
  ConsumerState<AddPage> createState() => _AddPageState();
}

class _AddPageState extends ConsumerState<AddPage> {


  final detailController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();

  final _form = GlobalKey<FormState>();


  String brand = items[0];
  String category = items1[0];

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
                          child: image == null ? Center(child: Text('Please select an image')): Image.file(File(image.path)),

                        ),
                      ),
                      Sizes.gapH20,
                      ElevatedButton(
                          onPressed:crud.isLoad ? null: () {
                            FocusScope.of(context).unfocus();
                            _form.currentState!.save();
                            if (_form.currentState!.validate()) {
                              if(image == null){

                              }else{
                                ref.read(crudProvider.notifier).addProduct(
                                    product_name: nameController.text.trim(),
                                    product_detail: detailController.text.trim(),
                                    product_price: int.parse(priceController.text.trim()),
                                    product_image: image,
                                    brand: brand,
                                    category: category,
                                    countInStock: int.parse(stockController.text.trim()),
                                    token: auth.user!.token
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
