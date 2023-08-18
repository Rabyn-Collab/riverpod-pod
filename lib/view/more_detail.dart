import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/api.dart';
import 'package:pod/common_widgets/snack_widget.dart';
import 'package:pod/model/product.dart';
import 'package:pod/providers/auth_provider.dart';
import 'package:pod/providers/product_provider.dart';
import 'package:pod/service/product_service.dart';

import '../constants/gap.dart';

class Rate{
  final String label;
  final int value;
  Rate({
    required this.label,
    required this.value
  });
}

final rateItem = [
  Rate(label: 'Excellent', value: 5),
  Rate(label: 'Very Good', value: 4),
  Rate(label: 'Good', value: 3),
  Rate(label: 'ok', value: 2),
  Rate(label: 'bad', value: 1),
];


class MoreDetail extends ConsumerStatefulWidget {
  final Product product;
  const MoreDetail({super.key, required this.product});

  @override
  ConsumerState<MoreDetail> createState() => _MoreDetailState();
}

class _MoreDetailState extends ConsumerState<MoreDetail> {




  double val = 1;
  final commentController = TextEditingController();
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    ref.listen(crudProvider, (previous, next) {
      if(next.isError){
        CommonSnack.errrorSnack(context: context,msg:  next.errText);
      }else if(next.isSuccess){
        ref.invalidate(productProvider);
        CommonSnack.successSnack(context: context,msg:  'successfully added a comment');
      }
    });
    final crud = ref.watch(crudProvider);

    return Scaffold(
        body: SafeArea(
          child: ListView(
            children: [
              Container(
                  height: 270,
                  width: double.infinity,
                  child: Hero(
                      tag: widget.product.id,
                      child: CachedNetworkImage(imageUrl: '${Api.baseUrl}${widget.product.product_image}'))),
              Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.product.product_name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      SizedBox(height: 20,),


                    ],
                  )),
              Form(
                key: _form,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: commentController,
                        maxLines: 3,
                        decoration: InputDecoration(
                            hintText: 'add some comment',
                            border: OutlineInputBorder()
                        ),
                      ),
                      Sizes.gapH20,
                      RatingBar.builder(
                        initialRating: 0,
                        itemSize: 15,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: rateItem.length,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                         setState(() {
                           val = rating;
                         });
                        },
                      ),
                      Align(
                         alignment: Alignment.bottomRight,
                          child: Consumer(
                              builder: (context, ref, child) {
                                final auth = ref.watch(authProvider);
                                return TextButton(
                                    onPressed: crud.isLoad ? null : () {
                                      FocusScope.of(context).unfocus();
                                      ref.read(crudProvider.notifier).addRating(
                                          username: auth.user!.fullname,
                                          comment: commentController.text.trim(),
                                          rating: val.floor(),
                                          user: auth.user!.id,
                                          productId: widget.product.id,
                                          token: auth.user!.token
                                      );
                                    }, child:crud.isLoad ? Center(child: CircularProgressIndicator()): Text('Submit'));
                              }
              )
                )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
