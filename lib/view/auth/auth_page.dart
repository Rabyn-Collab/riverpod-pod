import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/common_widgets/snack_widget.dart';
import 'package:pod/constants/colors.dart';
import 'package:pod/constants/gap.dart';
import 'package:pod/providers/auth_provider.dart';
import 'package:pod/providers/mode.dart';


class AuthPage extends ConsumerStatefulWidget {


  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final mailController = TextEditingController();

  final nameController = TextEditingController();

  final passController = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if(next.isError){
        CommonSnack.errrorSnack(context: context,msg:  next.errText);
      }else if(next.isSuccess){
        CommonSnack.successSnack(context: context,msg:  'successfully register');
        Get.back();
      }
    });
    final auth = ref.watch(authProvider);
    final isLogin = ref.watch(loginProvider);
    final image = ref.watch(imageProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(isLogin ? 'Login Page' : 'SignUp Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Consumer(
              builder: (context, ref, child) {
                final mode = ref.watch(modeProvider);
                return Form(
                  autovalidateMode: mode,
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 50,),
                    if(!isLogin)  TextFormField(
                        controller: nameController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colours.whiteColor),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'please provide username';
                          } else if (val.length < 5) {
                            return 'must be greater than 5';
                          } else if (val.length > 30) {
                            return 'must be less than 30';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'User Name',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            prefixIcon: Icon(Icons.lock),
                            errorStyle: TextStyle(color: Colors.amber)
                        ),
                      ),
                      Sizes.gapH16,
                      TextFormField(
                        style: TextStyle(color: Colours.whiteColor),
                        controller: mailController,
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'please provide email';
                          } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val)) {
                            return 'please provide valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'email',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            prefixIcon: Icon(Icons.email),
                            errorStyle: TextStyle(color: Colors.amber)
                        ),
                      ),
                      Sizes.gapH16,
                      TextFormField(
                        obscureText: true,
                        controller: passController,
                        style: TextStyle(color: Colours.whiteColor),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'please provide password';
                          } else if (val.length < 5) {
                            return 'must be greater than 5';
                          } else if (val.length > 20) {
                            return 'must be less than 20';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'password',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            prefixIcon: Icon(Icons.lock),
                            errorStyle: TextStyle(color: Colors.amber)
                        ),
                      ),
                      Sizes.gapH20,
                   if(!isLogin)   Sizes.gapH20,
                      if(!isLogin)    InkWell(
                        onTap: (){
                          ref.read(imageProvider.notifier).pickAnImage(false);
                        },
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white)
                          ),
                          child: image == null ?  Center(child: Text('Please select an image')) : Image.file(File(image.path)),
                        ),
                      ),
                      Sizes.gapH20,
                      ElevatedButton(
                          onPressed:auth.isLoad ? null: () {
                            FocusScope.of(context).unfocus();
                            _form.currentState!.save();
                            if (_form.currentState!.validate()) {

                            } else {
                              ref.read(modeProvider.notifier).changeMode();

                            }
                          }, child:  auth.isLoad ? Center(child: CircularProgressIndicator()) :Text('SignUp')
                      ),
                      Sizes.gapH10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(isLogin ? 'Don\'t have an account': 'Already have an Account ?'),
                          TextButton(onPressed: (){
                            ref.read(loginProvider.notifier).changeState();
                          }, child: Text(isLogin ? 'SignUp': 'Login'))
                        ],
                      )
                    ],
                  ),
                );
              }
          ),
        )
    );
  }
}
