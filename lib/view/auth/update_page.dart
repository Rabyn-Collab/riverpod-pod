import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/common_widgets/snack_widget.dart';
import 'package:pod/constants/colors.dart';
import 'package:pod/constants/gap.dart';
import 'package:pod/model/post.dart';
import 'package:pod/providers/mode.dart';
import 'package:pod/providers/post_provider.dart';


class UpdatePage extends ConsumerStatefulWidget {
  final Post post;
  UpdatePage(this.post);


  @override
  ConsumerState<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends ConsumerState<UpdatePage> {
  TextEditingController titleController = TextEditingController();

  TextEditingController detailController = TextEditingController();



  final _form = GlobalKey<FormState>();


  @override
  void initState() {
    titleController..text = widget.post.title;
    detailController..text = widget.post.detail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    ref.listen(postProvider, (previous, next) {

      if(next.isError){
        CommonSnack.errrorSnack(context: context,msg:  next.errText);
      }else if(next.isSuccess){
        CommonSnack.successSnack(context: context,msg:  'successfully added');
        Get.back();
      }
    });
    final post = ref.watch(postProvider);

    final image = ref.watch(imageProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Page'),
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
                      const SizedBox(height: 50,),

                      Sizes.gapH16,
                      TextFormField(
                        style: TextStyle(color: Colours.whiteColor),
                        controller: titleController,
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'please provide title';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'Title',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            prefixIcon: Icon(Icons.temple_buddhist_outlined),
                            errorStyle: TextStyle(color: Colors.amber)
                        ),
                      ),
                      Sizes.gapH16,
                      TextFormField(
                        controller: detailController,
                        style: TextStyle(color: Colours.whiteColor),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'please provide detail';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'Detail',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            prefixIcon: Icon(Icons.info),
                            errorStyle: TextStyle(color: Colors.amber)
                        ),
                      ),
                      Sizes.gapH20,

                      InkWell(
                        onTap: (){
                          ref.read(imageProvider.notifier).pickAnImage(false);
                        },
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white)
                          ),
                          child: image == null ?  Image.network(widget.post.imageUrl) : Image.file(File(image.path)),
                        ),
                      ),
                      Sizes.gapH20,
                      ElevatedButton(
                          onPressed : post.isLoad ? null: () {
                            FocusScope.of(context).unfocus();
                            _form.currentState!.save();
                            if (_form.currentState!.validate()) {

                              if(image == null){
                                CommonSnack.errrorSnack(context: context, msg: 'please select an image');
                              }else{
                                ref.read(postProvider.notifier).addPost(
                                    detail: detailController.text.trim(),
                                    title: titleController.text.trim(),
                                    userId: FirebaseAuth.instance.currentUser!.uid,
                                    image: image
                                );
                              }



                            } else {
                              ref.read(modeProvider.notifier).changeMode();

                            }
                          }, child:  post.isLoad ? Center(child: CircularProgressIndicator()) :Text('Submit')
                      ),
                      Sizes.gapH10,

                    ],
                  ),
                );
              }
          ),
        )
    );
  }
}
